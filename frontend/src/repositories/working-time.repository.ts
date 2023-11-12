import axios from 'axios';
import type { WorkingTimeInterface } from '@/models/WorkingTimeInterface';
export default class WorkingTimeRepository {

    static fetchWorkingTimesbetween(start: string, end: string): Promise<WorkingTimeInterface[]> {
        return axios.get(`http://localhost:4000/api/workingtimes?start=${start}&end=${end}`);
    }

    static fetchWorkingTimeByUserId(id: number, userId: number): Promise<WorkingTimeInterface> {
        return axios.get(`http://localhost:4000/api/workingtimes/${userId}/${id}`);
    }

    static createWorkingTime(userId: number, workingTime: WorkingTimeInterface): Promise<WorkingTimeInterface> {
        return axios.post(`http://localhost:4000/api/workingtimes/${userId}`, workingTime);
    }

    static updateWorkingTime(id: number, workingTime: WorkingTimeInterface): Promise<WorkingTimeInterface> {
        return axios.put(`http://localhost:4000/api/workingtimes/${id}`, workingTime);
    }

    static deleteWorkingTime(id: number): Promise<void> {
        return axios.delete(`http://localhost:4000/api/workingtimes/${id}`);
    }
}