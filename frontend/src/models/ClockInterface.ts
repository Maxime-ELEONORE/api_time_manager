import type { UserInterface } from './UserInterface';
export default class ClockInterface {
    id: number;
    time: string;
    status: boolean;
    user: UserInterface;

    constructor(id: number, time: string, status: boolean, user: UserInterface) {
        this.id = id;
        this.time = time;
        this.status = status;
        this.user = user;
    }
}
