import React, { useState } from "react";
import Box from "@mui/material/Box";
import Button from "@mui/material/Button";
import ButtonGroup from "@mui/material/ButtonGroup";
import FormControlLabel from "@mui/material/FormControlLabel";
import List from "@mui/material/List";
import Radio from "@mui/material/Radio";
import RadioGroup from "@mui/material/RadioGroup";
import Typography from "@mui/material/Typography";
import { Question, selectedOption } from "../../../../types/survey";

const Survey: React.FC<any> = (props) => {
  const questions: Question[] = [];
  const [radioValue, setRadioValue] = useState("");
  const [selectedOptions, setSelectedOptions] = useState<Array<selectedOption>>(
    []
  );
  const [currentQuestion, setCurrentQuestion] = useState<Question>(
    questions[0]
  );

  const handleClickSelect = () => {
    if (radioValue === "") {
      alert("Select option");
      return;
    }

    let currentNumber = currentQuestion.id;

    if (currentNumber === questions.length) {
      window.location.href = "/thankyou";
    }

    setSelectedOptions([
      ...selectedOptions,
      { question_id: currentNumber, value: radioValue },
    ]);
    selectedOptions.push({ question_id: currentNumber, value: radioValue });

    setRadioValue("");
    setCurrentQuestion(questions[currentNumber]);
  };

  const handleClickBack = () => {
    if (selectedOptions.length != 0) {
      let currentNumber = currentQuestion.id;

      const copyArr = [...selectedOptions];
      copyArr.splice(-1);
      setSelectedOptions(copyArr);
      setCurrentQuestion(questions[currentNumber - 2]);
    }
  };

  const handleChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    setRadioValue((event.target as HTMLInputElement).value);
  };
  return (
    <Box sx={{ width: "50%", margin: "auto", bgcolor: "background.paper" }}>
      <Typography sx={{ mt: 4, mb: 2 }} variant="h6" component="div">
        {currentQuestion.id+
          "/" +
          questions.length +
          "：" +
          currentQuestion.description}
      </Typography>
      <List>
        <RadioGroup
          aria-labelledby="demo-controlled-radio-buttons-group"
          name="controlled-radio-buttons-group"
          value={radioValue}
          onChange={handleChange}
        >
          {(Object.keys(questions[0].options) as unknown as number[]).map(
            (choice, index) => (
              <FormControlLabel
                key={index}
                value={currentQuestion.options[choice]}
                control={<Radio />}
                label={currentQuestion.options[choice]}
              />
            )
          )}
        </RadioGroup>
      </List>
      <Box sx={{ textAlign: "right" }}>
        <ButtonGroup aria-label="outlined primary button group">
          <Button variant="text" onClick={handleClickSelect}>
            SELECT
          </Button>
          <Button variant="text" onClick={handleClickBack}>
            BACK
          </Button>
        </ButtonGroup>
      </Box>
    </Box>
  );
};

export default Survey;
