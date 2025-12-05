/*
  Warnings:

  - You are about to drop the column `amount` on the `Claim` table. All the data in the column will be lost.
  - You are about to drop the column `claimNo` on the `Claim` table. All the data in the column will be lost.
  - Added the required column `incidentType` to the `Claim` table without a default value. This is not possible if the table is not empty.
  - Added the required column `userId` to the `Claim` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX "Claim_claimNo_key";

-- AlterTable
ALTER TABLE "Claim" DROP COLUMN "amount",
DROP COLUMN "claimNo",
ADD COLUMN     "incidentType" TEXT NOT NULL,
ADD COLUMN     "userId" TEXT NOT NULL,
ALTER COLUMN "status" SET DEFAULT 'PENDING';

-- CreateTable
CREATE TABLE "Evidence" (
    "id" TEXT NOT NULL,
    "url" TEXT NOT NULL,
    "fileName" TEXT NOT NULL,
    "fileType" TEXT,
    "claimId" TEXT NOT NULL,
    "createdAt" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Evidence_pkey" PRIMARY KEY ("id")
);

-- AddForeignKey
ALTER TABLE "Claim" ADD CONSTRAINT "Claim_userId_fkey" FOREIGN KEY ("userId") REFERENCES "User"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Evidence" ADD CONSTRAINT "Evidence_claimId_fkey" FOREIGN KEY ("claimId") REFERENCES "Claim"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
