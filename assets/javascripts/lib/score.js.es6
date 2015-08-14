export function scoreIs(score) {
  if (score < 0) {
    return 0;
  } else if (score < 5) {
    return 1;
  } else if (score < 10) {
    return 2;
  }

  return 3;
};

export function statusIs(score) {
  let status = ['D', 'C', 'B', 'A'];

  return status[scoreIs(score)];
};

export let ratings =
  [
    { name: 'A', selected: false },
    { name: 'B', selected: false },
    { name: 'C', selected: false },
    { name: 'D', selected: false }
  ]

export let issueTypes =
  [
    { name: 'strict-transport-security', selected: false },
    { name: 'x-xss-protection', selected: false },
    { name: 'x-content-type-options', selected: false },
    { name: 'x-download-options', selected: false },
    { name: 'x-frame-options', selected: false },
    { name: 'public-key-pins', selected: false },
    { name: 'x-permitted-cross-domain-policies', selected: false }
  ]
