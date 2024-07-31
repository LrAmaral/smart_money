import { AppService } from './app.service';
import { Controller, Get } from '@nestjs/common';
import { User } from './user/entities/user.entity';
import { IsPublic } from './auth/decorators/is-public.decorator';
import { CurrentUser } from './auth/decorators/current-user.decorator';

@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @IsPublic()
  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get('me') // Só é possivel acessar passando o token
  getMe(@CurrentUser() user: User) {
    return user;
  }
}
