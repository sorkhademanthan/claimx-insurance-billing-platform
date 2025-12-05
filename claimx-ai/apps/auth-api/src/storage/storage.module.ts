import { Module } from '@nestjs/common';
import { StorageService } from './storage.service';

@Module({
  providers: [StorageService],
  exports: [StorageService], // 👈 Exporting is key!
})
export class StorageModule {}