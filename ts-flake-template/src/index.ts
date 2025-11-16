import _ from 'lodash';

function createRootContainer(): HTMLDivElement {
  const container = document.createElement('div');

  container.style.display = 'flex';
  container.style.flexDirection = 'column';
  container.style.justifyContent = 'center';
  container.style.alignItems = 'center';
  container.style.height = '100vh';
  container.style.fontFamily = 'system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", sans-serif';
  container.style.fontSize = '1.5rem';
  container.style.textAlign = 'center';
  container.style.gap = '2rem';
  container.style.padding = '1rem';

  return container;
}

function createHeaderMessage(): HTMLDivElement {
  const header = document.createElement('div');

  header.textContent = _.join(
    [
      'Congrats!',
      "You're running the TypeScript + Nix workshop environment successfully.",
      'Everything you are seeing is built from a fully reproducible setup'
    ],
    ' '
  );

  return header;
}

function createQuiz(): HTMLDivElement {
  const quizContainer = document.createElement('div');

  quizContainer.style.display = 'flex';
  quizContainer.style.flexDirection = 'column';
  quizContainer.style.alignItems = 'center';
  quizContainer.style.gap = '1rem';
  quizContainer.style.maxWidth = '600px';

  const question = document.createElement('div');
  question.style.fontSize = '1.25rem';
  question.textContent = 'Quick quiz: What is the main thing Nix gives you in this TypeScript workshop setup?';

  const buttonContainer = document.createElement('div');
  buttonContainer.style.display = 'flex';
  buttonContainer.style.flexDirection = 'column';
  buttonContainer.style.gap = '0.5rem';
  buttonContainer.style.width = '100%';

  const options: { label: string; correct: boolean }[] = [
    {
      label: 'A) It guarantees your code will never have bugs.',
      correct: false
    },
    {
      label: 'B) It guarantees a reproducible dev environment with the same tools on every machine.',
      correct: true
    },
    {
      label: 'C) It makes pnpm faster than any other package manager.',
      correct: false
    }
  ];

  const feedback = document.createElement('div');
  feedback.style.fontSize = '1.1rem';
  feedback.style.fontWeight = 'bold';

  options.forEach(option => {
    const button = document.createElement('button');
    button.textContent = option.label;
    button.style.padding = '0.5rem 1rem';
    button.style.fontSize = '1rem';
    button.style.cursor = 'pointer';
    button.style.borderRadius = '0.5rem';
    button.style.border = '1px solid #444';
    button.style.backgroundColor = '#f5f5f5';

    button.addEventListener('mouseover', () => {
      button.style.backgroundColor = '#e0e0e0';
    });

    button.addEventListener('mouseout', () => {
      button.style.backgroundColor = '#f5f5f5';
    });

    button.addEventListener('click', () => {
      if (option.correct) {
        feedback.textContent = 'Correct! Nix makes the dev environment reproducible, so everyone gets the same tools and versions.';
        feedback.style.color = '#15803d';
      } else {
        feedback.textContent = 'Not quite. Nix focuses on making the environment reproducible, not on magically fixing code or performance.';
        feedback.style.color = '#b91c1c';
      }
    });

    buttonContainer.appendChild(button);
  });

  quizContainer.appendChild(question);
  quizContainer.appendChild(buttonContainer);
  quizContainer.appendChild(feedback);

  return quizContainer;
}

function main(): void {
  const root = createRootContainer();
  const header = createHeaderMessage();
  const quiz = createQuiz();

  root.appendChild(header);
  root.appendChild(quiz);
  document.body.appendChild(root);
}

main();
