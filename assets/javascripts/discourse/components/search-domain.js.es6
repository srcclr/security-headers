import TextField from 'discourse/components/text-field';

const MIN_LENGTH = 3;
const TIME_TO_WAIT_BEFORE_UPDATE_RESULTS = 500;

function validSearchValue(value) {
  return value.length >= MIN_LENGTH;
}

export default TextField.extend({
  type: 'search',

  resultValue: '',

  setDefaultValue: function() {
    this.set('value', this.get('resultValue'));
  }.on('init'),

  updateResult() {
    this.set('resultValue', this.get('value'));
  },

  valueChanged: Em.observer('value', function() {
    let value = this.get('value');

    if (!validSearchValue(value)) { return '' };

    Em.run.debounce(this, this.updateResult, TIME_TO_WAIT_BEFORE_UPDATE_RESULTS);
  })
})
