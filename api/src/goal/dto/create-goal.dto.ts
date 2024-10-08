import { IsNumber, IsString } from 'class-validator';
import { Goal } from '../entities/goal.entity';

export class CreateGoalDto extends Goal {
  @IsString()
  user_id: string;

  @IsString()
  title: string;

  @IsNumber()
  amount: number;

  @IsNumber()
  balance: number;
}
