import { Injectable, OnModuleInit, InternalServerErrorException, Logger } from '@nestjs/common';
import * as Minio from 'minio';
import 'multer'; // Ensure types are loaded

@Injectable()
export class StorageService implements OnModuleInit {
  private minioClient: Minio.Client;
  private bucketName = 'claim-evidence';
  private logger = new Logger(StorageService.name);

  constructor() {
    this.minioClient = new Minio.Client({
      endPoint: 'localhost',
      port: 9000,
      useSSL: false,
      accessKey: 'minioadmin',
      secretKey: 'minioadmin',
    });
  }

  // 👇 AUTOMATIC SETUP WHEN APP STARTS
  async onModuleInit() {
    await this.ensureBucketExists();
  }

  private async ensureBucketExists() {
    try {
      const exists = await this.minioClient.bucketExists(this.bucketName);
      if (!exists) {
        this.logger.log(`🪣 Bucket '${this.bucketName}' not found. Creating...`);
        await this.minioClient.makeBucket(this.bucketName, 'us-east-1');
        
        // Make it public (Readable by anyone)
        const policy = {
          Version: '2012-10-17',
          Statement: [
            {
              Effect: 'Allow',
              Principal: { AWS: ['*'] },
              Action: ['s3:GetObject'],
              Resource: [`arn:aws:s3:::${this.bucketName}/*`],
            },
          ],
        };
        await this.minioClient.setBucketPolicy(this.bucketName, JSON.stringify(policy));
        this.logger.log(`✅ Bucket '${this.bucketName}' created and set to public.`);
      } else {
        this.logger.log(`ℹ️ Bucket '${this.bucketName}' already exists.`);
      }
    } catch (error) {
      this.logger.error('❌ Failed to initialize MinIO bucket', error);
    }
  }

  async uploadFile(file: Express.Multer.File) {
    const fileName = `${Date.now()}-${file.originalname}`;
    
    try {
      await this.minioClient.putObject(
        this.bucketName,
        fileName,
        file.buffer,
        file.size
      );

      return {
        url: `http://localhost:9000/${this.bucketName}/${fileName}`,
        fileName: fileName
      };
    } catch (error) {
      this.logger.error('MinIO Upload Error:', error);
      throw new InternalServerErrorException('Failed to upload file');
    }
  }
}