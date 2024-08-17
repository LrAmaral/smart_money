import { IsEmail, IsString } from 'class-validator';

export class LoginRequestBody {
  @IsEmail({}, { message: 'Email inválido' })
  email: string;

  @IsString()
  password: string;
}
