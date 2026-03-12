-- Supabase SQL Seed Script: Migrate Demo Jobs
-- Instructions: 
-- 1. Create a Provider account in your app (if you don't have one).
-- 2. Find your Provider ID (UUID) in the 'provider_profiles' table.
-- 3. Replace 'YOUR_PROVIDER_ID_HERE' below with that UUID.
-- 4. Run this script in the Supabase SQL Editor.

-- Note: We use gen_random_uuid() to ensure valid UUIDs for PostgreSQL.

INSERT INTO jobs (
    id, 
    title, 
    company, 
    location, 
    salary_min, 
    salary_max, 
    description, 
    qualification, 
    experience, 
    required_skills, 
    has_accommodation, 
    has_food, 
    has_transport, 
    status, 
    provider_id,
    created_at
) VALUES 
(
    gen_random_uuid(), 'Construction Worker', 'TN Builders Ltd', 'Chennai', 15000, 25000, 
    'Looking for energetic construction workers for a major residential project in Chennai. Must be comfortable working at heights and following safety protocols. Daily meals provided.',
    '8th Pass / Basic Literacy', '1-3 Years', ARRAY['Masonry', 'Concrete Work', 'Safety Protocols'], 
    true, true, false, 'active', 'YOUR_PROVIDER_ID_HERE', NOW()
),
(
    gen_random_uuid(), 'Plumber', 'Urban Build Co', 'Chennai', 16000, 24000, 
    'Experienced plumbers needed for high-rise apartment maintenance. Should know PEX and PVC piping systems. Tools will be provided by the company.',
    'ITI in Plumbing preferred', '2+ Years', ARRAY['Plumbing', 'Pipe Fitting', 'Carpentry'], 
    false, false, true, 'active', 'YOUR_PROVIDER_ID_HERE', NOW()
),
(
    gen_random_uuid(), 'Electrician Helper', 'Spark Solutions', 'Chennai', 14000, 22000, 
    'Assist lead electricians in industrial wiring projects. Great opportunity for fresh ITI graduates to learn on the job. Safety gear is mandatory.',
    '10th Pass / ITI Pursuing', 'Fresher to 1 Year', ARRAY['Basic Electrical', 'Wiring', 'Safety Protocols'], 
    true, false, true, 'active', 'YOUR_PROVIDER_ID_HERE', NOW()
),
(
    gen_random_uuid(), 'Painter', 'Rainbow Interiors', 'Chennai', 13000, 20000, 
    'Interior and exterior painters required for commercial buildings. Must be skilled in spray painting and texture finishing. High attention to detail required.',
    'Literacy / Experience based', '2-4 Years', ARRAY['Painting', 'Surface Preparation', 'Quality Check'], 
    false, true, false, 'active', 'YOUR_PROVIDER_ID_HERE', NOW()
),
(
    gen_random_uuid(), 'Factory Operator', 'Auto Parts Mfg', 'Coimbatore', 18000, 28000, 
    'Operate automated assembly lines for automotive components. 8-hour shifts with overtime options. Clean and safe working environment.',
    'Diploma / ITI', '1-2 Years', ARRAY['Machine Operation', 'Quality Check', 'Assembly'], 
    true, false, true, 'active', 'YOUR_PROVIDER_ID_HERE', NOW()
),
(
    gen_random_uuid(), 'Welder', 'Steel Structures Co', 'Coimbatore', 20000, 30000, 
    'MIG/TIG welders for structural steel fabrication. Must be able to read blue-prints. Certification is a big plus. Overtime pay included.',
    'ITI Welder Certification', '3+ Years', ARRAY['Welding', 'Steel Fixing', 'Safety Protocols'], 
    true, true, false, 'active', 'YOUR_PROVIDER_ID_HERE', NOW()
),
(
    gen_random_uuid(), 'CNC Machine Operator', 'Precision Works', 'Coimbatore', 22000, 32000, 
    'Operator needed for VMC and CNC machines. Should be able to do basic offset corrections and tooling changes. Immediate joining preferred.',
    'Diploma in Mechanical', '2+ Years', ARRAY['CNC Operation', 'Machine Operation', 'AutoCAD Basics'], 
    false, false, true, 'active', 'YOUR_PROVIDER_ID_HERE', NOW()
),
(
    gen_random_uuid(), 'Textile Worker', 'Kavi Textiles', 'Coimbatore', 12000, 18000, 
    'Join our expanding textile unit. Roles available in weaving and quality inspection departments. Skill training provided for interested candidates.',
    '8th Pass / 10th Pass', 'Fresher Welcome', ARRAY['Textile Weaving', 'Quality Check', 'Machine Operation'], 
    true, true, true, 'active', 'YOUR_PROVIDER_ID_HERE', NOW()
),
(
    gen_random_uuid(), 'Warehouse Associate', 'Logistics Hub', 'Madurai', 12000, 20000, 
    'Maintain stock levels and assist in loading/unloading of shipments. Should be familiar with basic inventory software and safety rules.',
    '10th Pass / Inter', '1 Year', ARRAY['Loading', 'Inventory', 'Forklift'], 
    false, true, true, 'active', 'YOUR_PROVIDER_ID_HERE', NOW()
),
(
    gen_random_uuid(), 'Brick Layer', 'South India Constructions', 'Madurai', 14000, 22000, 
    'Specialist bricklayers for traditional and modern construction projects. Strong physical stamina and teamwork skills are essential.',
    'Skill-based', '2-5 Years', ARRAY['Masonry', 'Concrete Work', 'Safety Protocols'], 
    true, true, false, 'active', 'YOUR_PROVIDER_ID_HERE', NOW()
);
