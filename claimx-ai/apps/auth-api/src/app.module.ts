import { Module } from '@nestjs/common';
import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { PrismaModule } from './prisma/prisma.module';
import { PolicyModule } from './policy/policy.module';
import { ClaimModule } from './claim/claim.module';

@Module({
  imports: [AuthModule, UsersModule, PrismaModule, PolicyModule, ClaimModule],
})
export class AppModule {}

// claim id : 25c776eb-9ddd-4d3b-8f3f-480c4705689f
// policy id : a654b0ba-5f3e-4fb4-aa74-b3933d7f623e
// eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIwNTg3NWU0ZS1jMzM0LTRhOTQtYTQ0MS0wMGRjOTE4OTJjYWUiLCJlbWFpbCI6ImRlbW9AY2xhaW14LmNvbSIsInJvbGUiOiJ1c2VyIiwiaWF0IjoxNzY0OTY1MDMwLCJleHAiOjE3NjQ5Njg2MzB9.R2WMhVq6-xFWF02EfLyS27ljuwSKO70UhecAVZ9znqE