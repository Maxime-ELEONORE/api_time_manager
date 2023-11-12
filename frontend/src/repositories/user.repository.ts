import axios from 'axios';
import type {UserInterface} from "@/models/UserInterface";

export default class UserRepository {
    static fetchUserById(id: number): Promise<UserInterface> {
        let token = localStorage.getItem('token_auth') || '';
        return axios.get(`http://localhost:4000/api/users/${id}`, {
            headers: {
                Authorization: "Bearer " + token
            }
        });
    }

    static fetchUserByEmailAndUsername(email: string, username: string): Promise<UserInterface> {
        let token = localStorage.getItem('token_auth') || '';
        return axios.get(`http://localhost:4000/api/users?email=${email}&username=${username}`, {
            headers: {
                Authorization: "Bearer " + token
            }
        });
    }

    static fetchUsers(): Promise<UserInterface[]> {
        let token = localStorage.getItem('token_auth') || '';
        return axios.get(`http://localhost:4000/api/users`, {
            headers: {
                Authorization: "Bearer " + token
            }
        });
    }

    static createUser(user: UserInterface): Promise<UserInterface> {
        let token = localStorage.getItem('token_auth') || '';
        return axios.post(`http://localhost:4000/api/users`, user, {
            headers: {
                Authorization: "Bearer " + token
            }
        });
    }

    static updateUser(user: UserInterface): Promise<UserInterface> {
        let token = localStorage.getItem('token_auth') || '';
        return axios.put(`http://localhost:4000/api/users/${user.id}`, user, {
            headers: {
                Authorization: "Bearer " + token
            }
        });
    }

    static deleteUser(id: number): Promise<void> {
        let token = localStorage.getItem('token_auth') || '';
        return axios.delete(`http://localhost:4000/api/users/${id}`, {
            headers: {
                Authorization: "Bearer " + token
            }
        });
    }
}
