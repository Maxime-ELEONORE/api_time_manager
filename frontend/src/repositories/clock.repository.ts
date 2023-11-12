import axios from 'axios';
import ClockInterface from "@/models/ClockInterface";
export default class ClockRepository {
    static fetchClockByUserId(id: number): Promise<ClockInterface> {
        return axios.get(`http://localhost:4000/api/clocks/${id}`);
    }

    static createClockWithUserId(userId: number, clock: ClockInterface): Promise<ClockInterface> {
        return axios.post(`http://localhost:4000/api/clocks/${userId}`, clock);
    }
}