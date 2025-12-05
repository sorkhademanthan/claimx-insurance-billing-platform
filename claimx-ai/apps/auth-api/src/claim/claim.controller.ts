import { Controller, Post, Get, Body, Req, UseGuards, Param } from '@nestjs/common';
import { ClaimService } from './claim.service';
import { AuthGuard } from '@nestjs/passport';
import { CreateClaimDto } from './dto/create-claim.dto'; // Import the DTO

@UseGuards(AuthGuard('jwt'))
@Controller('claims')
export class ClaimController {
  constructor(private readonly claimService: ClaimService) {}

  @Post()
  create(@Body() body: CreateClaimDto, @Req() req: any) {
    return this.claimService.create(req.user.userId, body);
  }

  @Get()
  findAll(@Req() req: any) {
    return this.claimService.findAll(req.user.userId);
  }

  @Get(':id')
  findOne(@Param('id') id: string, @Req() req: any) {
      return this.claimService.findOne(id, req.user.userId);
  }
}