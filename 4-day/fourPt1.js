const fs = require("fs");

const filePath = "main-input.txt";

function generateSequenceTerm(n) {
  if (n === 0) return 0;

  return (1 * 2) ** (n - 1);
}

function sum(numbers) {
  return numbers.reduce((acc, curr) => acc + curr, 0);
}

function uniq(arr) {
  return [...new Set(arr)];
}

function removeDoubleSpaces(str) {
  return str.replace(/ {2,}/g, " ");
}

function scratchCardWinnings(cards) {
  const finalPoints = {};
  cards.forEach((card) => {
    const [cardDetails, numbers] = card.split(":");
    const [stippedCardDetails, strippedNumbers] = [cardDetails, numbers].map(
      removeDoubleSpaces
    );
    const [_, cardNumber] = stippedCardDetails.split(" ");
    const [winningNumbers, scratchNumbers] = strippedNumbers
      .split("|")
      .map((n) => n.trim());
    const winningNumbersArr = uniq(winningNumbers.split(" ").map((n) => +n));
    const scratchNumbersArr = scratchNumbers.split(" ").map((n) => +n);
    let winningNumbersCount = 0;
    scratchNumbersArr.forEach((n) => {
      if (winningNumbersArr.includes(n)) {
        winningNumbersCount++;
      }
    });
    finalPoints[cardNumber] = generateSequenceTerm(winningNumbersCount);
  });

  return sum(Object.values(finalPoints));
}

fs.readFile(filePath, "utf8", (err, data) => {
  const fileContent = fs.readFileSync(filePath, "utf8");
  const lines = fileContent.split("\n");
  const nonEmptyLines = lines.filter((line) => line.trim() !== "");

  console.log(scratchCardWinnings(nonEmptyLines));
});

// const testData = [
//   "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
//   "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
//   "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
//   "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
//   "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
//   "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11",
// ];

// console.log(scratchCardWinnings(testData) === 13);
