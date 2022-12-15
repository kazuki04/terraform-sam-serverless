export interface Choices {
  [key: number]: string;
}

export interface Question {
  questionNumber: number;
  questionDescription: string;
  choices: Choices;
}

export interface selectedOption {
  question_id: number;
  value: string;
}
