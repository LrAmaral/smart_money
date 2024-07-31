import { IsString } from 'class-validator';
import { Card } from '../entities/card.entity';

export class CreateCardDto extends Card {
  @IsString()
  user_id: string;

  @IsString()
  card_name: string;

  @IsString()
  bank: string;
}
