import type { UserInterface } from './UserInterface';

export interface WorkingTimeInterface {
    id: number;
    start: string;
    end: string;
    user: UserInterface;
}

