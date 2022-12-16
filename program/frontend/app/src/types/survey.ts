export interface Options {
  [key: number]: string;
}

export interface Question {
  id: number;
  description: string;
  options: Options;
}

export interface selectedOption {
  question_id: number;
  value: string;
}
