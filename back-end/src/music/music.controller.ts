import {
  Controller,
  Post,
  UploadedFile,
  UseInterceptors,
  Get,
  Param,
  Res,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { diskStorage } from 'multer';
import { Response } from 'express';
import * as path from 'path';   
import * as fs from 'fs';   

@Controller('music')
export class MusicController {
  @Post('upload')
  @UseInterceptors(
    FileInterceptor('audio', {
      storage: diskStorage({
        destination: './uploads/music',
        filename: (req, file, cb) => {
          const filename = `${Date.now()}-${file.originalname}`;
          cb(null, filename);
        },
      }),
    }),
  )
  uploadFile(@UploadedFile() file: Express.Multer.File) {
    return { message: 'File uploaded', filename: file.filename };
  }

@Get('lyrics/:id')
getLyrics(@Param('id') id: string) {


  const nonCommentedLyrics = [
    { time: 0, line: "ሰላ" },
    { time: 4, line: "ም" },
    { time: 5, line: "እ" },
    { time: 8, line: "ሰላ" },
    { time: 12, line: "ም" },
    { time: 14, line: "ሰላ" },
    { time: 17, line: "ም" },
    { time: 19, line: "እ" },
    { time: 22, line: "ሰላ" },
    { time: 25, line: "ም" },
    { time: 27, line: "እም ይእዜ" },
    { time: 31, line: "ሰ" },
    { time: 32, line: "ይ" },
    { time: 35, line: "ኩን" },
    { time: 37, line: "ሰ" },
    { time: 40, line: "ላም" },
    { time: 41, line: "እም ይእዜ" },
    { time: 47, line: "ሰ" },
    { time: 48, line: "ይ" },
    { time: 50, line: "ኩን" },
    { time: 52, line: "ሰ" },
    { time: 53, line: "ላም" },
  ];

  const commentedLyrics = [
    { time: 25, line: "ሞትን ዘለፈው ማሰሪያውን ቆረጠ" },
    { time: 31, line: "ማነው በፍቅሩ ያልተለወጠ" },
    { time: 38, line: "አዳነን ገዛን በደሙ" },
    { time: 43, line: "ምስጋና ይሁን ለስሙ" },
    { time: 47, line: "አዳነን ገዛን በደሙ" },
    { time: 52, line: "ምስጋና ይሁን ለስሙ" },
    { time: 55, line: "ሞትን ዘለፈው ማሰሪያውን ቆረጠ" },
    { time: 63, line: "ማነው በፍቅሩ ያልተለወጠ" },
    { time: 68, line: "አዳነን ገዛን በደሙ" },
    { time: 73, line: "ምስጋና ይሁን ለስሙ" },
    { time: 78, line: "አዳነን ገዛን በደሙ" },
    { time: 82, line: "ምስጋና ይሁን ለስሙ" },
    { time: 94, line: "ወረደ በአባቱ ፈቃድ" },
    { time: 99, line: "የእንባችንን ጅረት እንዲደርቅ" },
    { time: 103, line: "የሞትን ክንዱን ሰብሮልን" },
    { time: 108, line: "ሕይወትን ለብሰን ዘመርን" },
    { time: 113, line: "አቤቱ እንወድሃለን" },
    { time: 118, line: "ምስጋና ለአንተ እንሰጣለን" },
    { time: 122, line: "እልልታ ውዳሴ ቀናይ" },
    { time: 127, line: "ዘላለም ለአንተ አዶናይ/2/" },
    { time: 137, line: "ሞትን ዘለፈው ማሰሪያውን ቆረጠ" },
    { time: 143, line: "ማነው በፍቅሩ ያልተለወጠ" },
    { time: 150, line: "አዳነን ገዛን በደሙ" },
    { time: 155, line: "ምስጋና ይሁን ለስሙ" },
    { time: 170, line: "አዳነን ገዛን በደሙ" },
    { time: 175, line: "ምስጋና ይሁን ለስሙ" },
  ];

  return id === '1' ? nonCommentedLyrics : commentedLyrics;
}

}
