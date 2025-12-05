import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcrypt';

const prisma = new PrismaClient();

async function main() {
  const password = await bcrypt.hash('password123', 10);

  const demoUser = await prisma.user.upsert({
    where: { email: 'demo@claimx.com' },
    update: {},
    create: {
      email: 'demo@claimx.com',
      name: 'Demo User',
      password: password,
      role: 'user',
      policies: {
        create: {
          policyNumber: 'POL-12345678',
          type: 'AUTO',
          coverageAmount: 50000,
          startDate: new Date(),
          endDate: new Date(new Date().setFullYear(new Date().getFullYear() + 1)),
        }
      }
    },
  });

  console.log('🌱 Database seeded with user:', demoUser.email);
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });