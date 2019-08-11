class SoundEngine {
  constructor() {
    this.synth = new Tone.Synth().toMaster();
    $('.page__spread').on('click', this.onClick.bind(this))
  }

  onClick() {
    if (Tone.context.state !== 'running') {
      Tone.context.resume().then(() => {
        console.log('Playback resumed successfully');
      })
    }
    this.synth.triggerAttackRelease('C4', '2n');
  }
}

$(document).ready(function () {
  console.log('document ready');

  if (typeof(Tone) != "undefined") {
    soundEngine = new SoundEngine();
  }
});
