import { PrismaClient } from '@prisma/client';
import * as bcrypt from 'bcryptjs';

const prisma = new PrismaClient();

async function main() {
  // Hash a password for the seed user
  const password = await bcrypt.hash('password123', 10);

  // Create Alice with 2 Policies
  const alice = await prisma.user.upsert({
    where: { email: 'alice@example.com' },
    update: {},
    create: {
      email: 'alice@example.com',
      name: 'Alice Policyholder',
      password,
      role: 'user',
      policies: {
        create: [
          {
            policyNo: 'POL-123456789',
            type: 'motor',
            premium: 1200.50,
            startDate: new Date('2024-01-01'),
            endDate: new Date('2025-01-01'),
            status: 'active',
          },
          {
            policyNo: 'POL-987654321',
            type: 'home',
            premium: 850.00,
            startDate: new Date('2024-03-15'),
            endDate: new Date('2025-03-15'),
            status: 'active',
          },
        ],
      },
    },
  });

  console.log({ alice });
}

main()
  .catch((e) => {
    console.error(e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });
