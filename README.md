# Migrant Connect

A comprehensive digital platform designed to support migrant workers and job providers. This portal facilitates job searching, application tracking, and administrative management for migrant worker recruitment and support schemes.

## Features

- **Worker Portal**: Job search, profile management, and application tracking.
- **Provider Portal**: Job posting, applicant management, and company profile.
- **Admin Dashboard**: Oversight of workers, providers, jobs, and support schemes.
- **Multilingual Support**: Support for multiple languages to assist diverse workforces.
- **Email Notifications**: Automated notifications for job applications and status changes via Resend and Supabase Edge Functions.

## Tech Stack

- **Frontend**: React, Vite, TypeScript
- **Styling**: Tailwind CSS, shadcn/ui
- **Backend/Database**: Supabase (PostgreSQL, Auth, Storage)
- **Icons**: Lucide React
- **Notifications**: Resend

## Getting Started

### Prerequisites

- Node.js (v18 or higher)
- npm or bun

### Local Development

1. **Clone the repository**:
   ```sh
   git clone <repository-url>
   cd migrant-portal
   ```

2. **Install dependencies**:
   ```sh
   npm install
   ```

3. **Set up Environment Variables**:
   Create a `.env` file in the root directory and add your Supabase credentials:
   ```env
   VITE_SUPABASE_URL=your_supabase_url
   VITE_SUPABASE_ANON_KEY=your_supabase_anon_key
   ```

4. **Start the development server**:
   ```sh
   npm run dev
   ```

## Deployment

The project can be deployed to platforms like **Vercel** or **Netlify**.

### Supabase Configuration for Production

To ensure authentication (like email verification) works correctly:

1. In your Supabase Dashboard, go to **Authentication > Settings**.
2. Set **Site URL** to your production URL (e.g., `https://migrant-portal.vercel.app`).
3. Add `https://migrant-portal.vercel.app/**` to **Additional Redirect URLs**.

## License

MIT
