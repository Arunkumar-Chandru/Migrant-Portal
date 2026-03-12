// supabase/functions/send-application-email/index.ts
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'

const RESEND_API_KEY = Deno.env.get('RESEND_API_KEY')

serve(async (req) => {
    try {
        const payload = await req.json()
        const { record } = payload

        const supabase = createClient(
            Deno.env.get('SUPABASE_URL') ?? '',
            Deno.env.get('SUPABASE_SERVICE_ROLE_KEY') ?? ''
        )

        // 1. Fetch worker and job details
        const { data: { user: worker }, error: workerError } = await supabase.auth.admin.getUserById(record.worker_id)
        if (workerError) throw workerError

        const { data: job, error: jobError } = await supabase
            .from('jobs')
            .select('title, company, provider_id')
            .eq('id', record.job_id)
            .single()
        if (jobError) throw jobError

        // 2. Fetch provider details
        const { data: provider, error: providerError } = await supabase
            .from('provider_profiles')
            .select('contact_email, contact_person')
            .eq('id', job.provider_id)
            .single()
        if (providerError) throw providerError

        const workerEmail = worker?.email
        const providerEmail = provider?.contact_email
        const jobTitle = job?.title
        const company = job?.company
        const workerName = worker?.user_metadata?.full_name || "A worker"

        const emails = []

        // Email to Worker
        if (workerEmail) {
            emails.push({
                from: 'Migrant Connect <notifications@resend.dev>',
                to: workerEmail,
                subject: `Application Successful: ${jobTitle}`,
                html: `
          <h1>Application Received!</h1>
          <p>You have successfully applied for <strong>${jobTitle}</strong> at <strong>${company}</strong>.</p>
          <p>The provider will contact you if they are interested.</p>
        `,
            })
        }

        // Email to Provider
        if (providerEmail) {
            emails.push({
                from: 'Migrant Connect <notifications@resend.dev>',
                to: providerEmail,
                subject: `New Application: ${jobTitle}`,
                html: `
          <h1>New Job Application!</h1>
          <p>A worker (${workerName}) has applied for your job: <strong>${jobTitle}</strong>.</p>
          <p>Log in to the Provider Portal to review their profile.</p>
        `,
            })
        }

        // Send all emails
        const results = await Promise.all(emails.map(email =>
            fetch('https://api.resend.com/emails', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'Authorization': `Bearer ${RESEND_API_KEY}`,
                },
                body: JSON.stringify(email),
            })
        ))

        return new Response(JSON.stringify({ success: true, results }), {
            headers: { 'Content-Type': 'application/json' },
            status: 200,
        })
    } catch (error: any) {
        return new Response(JSON.stringify({ error: error.message }), {
            headers: { 'Content-Type': 'application/json' },
            status: 400,
        })
    }
})
