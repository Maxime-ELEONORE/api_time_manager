import Axios, { type AxiosRequestConfig, type AxiosResponse } from "axios";

export class AxiosService {
  token: string | null;
  constructor(private readonly axios: typeof Axios) {
    this.token = localStorage.getItem("token");
  }

  public async get(url: string, options?: AxiosRequestConfig): Promise<AxiosResponse<any>> {
    return await this.axios.get(url, {
      ...options,
      headers: {
        Authorization: `Bearer ${this.token}`,
      },
    });
  }

  public async post(url: string, data: any, options?: AxiosRequestConfig): Promise<AxiosResponse<any>> {
    return await this.axios.post(url, data, {
      ...options,
      headers: {
        Authorization: `Bearer ${this.token}`,
      },
    });
  }

  public async put(url: string, data: any, options?: AxiosRequestConfig): Promise<AxiosResponse<any>> {
    return await this.axios.put(url, data, {
      ...options,
      headers: {
        Authorization: `Bearer ${this.token}`,
      },
    });
  }

  public async delete(url: string, options?: AxiosRequestConfig): Promise<AxiosResponse<any>> {
    return await this.axios.delete(url, {
      ...options,
      headers: {
        Authorization: `Bearer ${this.token}`,
      },
    });
  }
}
