import { IsNumber, IsString } from 'class-validator';
import { Transaction } from '../entities/transaction.entity';

export class CreateTransactionDto extends Transaction {
  @IsString()
  user_id: string;

  @IsString()
  title: string;

  @IsString()
  type: string;

  @IsString()
  category: string;

  @IsString()
  description: string;

  @IsNumber()
  amount: number;
}
