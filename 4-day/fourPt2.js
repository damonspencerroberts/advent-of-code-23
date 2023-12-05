const fs = require("fs");

const filePath = "main-input.txt";

fs.readFile(filePath, "utf8", (err, data) => {
  const fileContent = fs.readFileSync(filePath, "utf8");
  const lines = fileContent.split("\n");
  const nonEmptyLines = lines.filter((line) => line.trim() !== "");

  console.log(generateAnswers(nonEmptyLines));
});

// Not my answer - got stuck on this one
function generateAnswers(input) {
  let part1 = 0;
  const cardInstances = new Array(input.length).fill(1);

  input.forEach((line, idx) => {
    const [, winning, card] = line.split(/[:|]/g);
    const winningNums = winning.trim().split(/\s+/).map(Number);
    const cardNums = card.trim().split(/\s+/).map(Number);
    const matchCount = cardNums.filter((num) =>
      winningNums.includes(num)
    ).length;

    if (matchCount) {
      const points = 2 ** (matchCount - 1);
      part1 += points;

      for (let i = idx + 1; i <= idx + matchCount; i++) {
        cardInstances[i] += cardInstances[idx];
      }
    }
  });

  return cardInstances.reduce((acc, v) => acc + v, 0);
}

const testData = [
  "Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53",
  "Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19",
  "Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1",
  "Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83",
  "Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36",
  "Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11",
];

console.log(generateAnswers(testData));
