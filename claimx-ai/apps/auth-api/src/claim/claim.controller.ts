import 'multer'; // 👈 Forces TS to load the Multer types
import { Controller, Post, Get, Body, Req, UseGuards, Param, UploadedFile, UseInterceptors } from '@nestjs/common';
import { ClaimService } from './claim.service';
import { AuthGuard } from '@nestjs/passport';
import { CreateClaimDto } from './dto/create-claim.dto';
import { FileInterceptor } from '@nestjs/platform-express';
import { StorageService } from '../storage/storage.service';

@UseGuards(AuthGuard('jwt'))
@Controller('claims')
export class ClaimController {
  constructor(
    private readonly claimService: ClaimService,
    private readonly storageService: StorageService
  ) {}

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

  @Post(':id/upload')
  @UseInterceptors(FileInterceptor('file'))
  async uploadEvidence(
    @Param('id') id: string,
    @UploadedFile() file: Express.Multer.File
  ) {
    return this.storageService.uploadFile(file);
  }
}

