import { randomUUID } from 'node:crypto';
import { Injectable } from '@nestjs/common';
import { CreateCardDto } from './dto/create-card.dto';
import { UpdateCardDto } from './dto/update-card.dto';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class CardService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createCardDto: CreateCardDto) {
    return await this.prisma.card.create({
      data: {
        id: randomUUID(),
        ...createCardDto,
      },
    });
  }

  //Método que somente o admin poderá acessar
  findAll() {
    return this.prisma.card.findMany();
  }

  findOne(id: string) {
    return this.prisma.card.findUnique({
      where: { id },
    });
  }

  async update(id: string, updateCardDto: UpdateCardDto) {
    return await this.prisma.card.update({
      where: { id },
      data: { ...updateCardDto },
    });
  }

  async remove(id: string) {
    return await this.prisma.card
      .delete({
        where: { id },
      })
      .then(() => {
        return { message: 'Card deleted successfully' };
      });
  }
}
