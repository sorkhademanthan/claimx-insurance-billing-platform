import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  const password = await bcrypt.hash('password123', 10);

  const USER_ID = '97920a11-240d-4925-ab46-14e7c6709a66';
  const POLICY_ID = '7f54e808-4761-4c0b-8999-4727142ffe5c';

  console.log('🧹 Cleaning up old data...');
  // Delete in order to respect foreign keys
  try {
    await prisma.evidence.deleteMany({});
    await prisma.claim.deleteMany({});
    await prisma.policy.deleteMany({});
    // Delete the specific demo user if exists
    await prisma.user.deleteMany({ where: { email: 'demo@claimx.com' } });
  } catch (error) {
    console.log('⚠️ Cleanup warning (ignorable if DB was empty):', error);
  }

  console.log('🌱 Seeding fresh data...');
  
  // Create User with Fixed ID
  const demoUser = await prisma.user.create({
    data: {
      id: USER_ID,
      email: 'demo@claimx.com',
      name: 'Demo User',
      password: password,
      role: 'user',
      policies: {
        create: {
          id: POLICY_ID,
          policyNumber: 'POL-12345678',
          type: 'AUTO',
          coverageAmount: 50000,
          startDate: new Date(),
          endDate: new Date(new Date().setFullYear(new Date().getFullYear() + 1)),
        }
      }
    },
  });

  console.log('✅ Database seeded successfully!');
  console.log('👤 User:', demoUser.email);
  console.log('🆔 User ID:', USER_ID);
  console.log('📄 Policy ID:', POLICY_ID);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });