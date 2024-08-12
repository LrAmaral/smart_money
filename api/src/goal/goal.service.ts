import { randomUUID } from 'node:crypto';
import { Injectable } from '@nestjs/common';
import { CreateGoalDto } from './dto/create-goal.dto';
import { UpdateGoalDto } from './dto/update-goal.dto';
import { PrismaService } from 'src/prisma/prisma.service';

@Injectable()
export class GoalService {
  constructor(private readonly prisma: PrismaService) {}

  async create(createGoalDto: CreateGoalDto) {
    return await this.prisma.goal.create({
      data: {
        id: randomUUID(),
        ...createGoalDto,
      },
    });
  }

  findAll() {
    return this.prisma.goal.findMany();
  }

  findOne(id: string) {
    return this.prisma.goal.findUnique({
      where: { id },
    });
  }

  async update(id: string, updateGoalDto: UpdateGoalDto) {
    return await this.prisma.goal.update({
      where: { id },
      data: { ...updateGoalDto },
    });
  }

  async remove(id: string) {
    return await this.prisma.goal
      .delete({
        where: { id },
      })
      .then(() => {
        return { message: 'Goal deleted successfully' };
      });
  }
}
