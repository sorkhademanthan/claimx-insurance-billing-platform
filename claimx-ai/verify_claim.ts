import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  console.log('🔍 Verifying latest claim...');
  
  const latestClaim = await prisma.claim.findFirst({
    orderBy: { createdAt: 'desc' },
    include: { policy: true, user: true }
  });

  if (!latestClaim) {
    console.log('❌ No claims found in the database.');
    return;
  }

  console.log('✅ Latest Claim Found in Postgres:');
  console.log('-----------------------------------');
  console.log(`ID:           ${latestClaim.id}`);
  console.log(`Status:       ${latestClaim.status}`);
  console.log(`Type:         ${latestClaim.incidentType}`);
  console.log(`Description:  ${latestClaim.description}`);
  console.log(`Date:         ${latestClaim.incidentDate}`);
  console.log(`Policy:       ${latestClaim.policy.policyNumber}`);
  console.log(`User:         ${latestClaim.user.email}`);
  console.log('-----------------------------------');
}

main()
  .catch(e => console.error(e))
  .finally(async () => await prisma.$disconnect());
