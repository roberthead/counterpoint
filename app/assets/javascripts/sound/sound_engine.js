$(document).ready(function () {
  console.log('document ready');

  if (typeof(Tone) != "undefined") {
    soundEngine = new SoundEngine();
  }
});

class SoundEngine {
  constructor() {
    Tone.Transport.bpm.value = 140
    $('.page__spread').on('click', this.onClick.bind(this));
    this.sequence = new Sequence();
  }

  onClick() {
    if (Tone.context.state !== 'running') {
      Tone.context.resume().then(() => {
        console.log('Playback resumed successfully');
      })
    }
    this.sequence.play()
  }
}

class Sequence {
  constructor() {
    this.synth = new Tone.PolySynth().toMaster();
    this.bars = []
    this._loadMusic();
  }

  _loadMusic() {
    let $cantusFirmusNotes = $('.sandbox__note-link--cantus-firmus').parent()
    let $counterpointNotes = $('.sandbox__note-link--counterpoint').parent()
    let pitches, bar;
    for (let barNumber = 1; barNumber < 20; barNumber++) {
      pitches = this._cantusFirmusPitchesForBar(barNumber).concat(this._counterpointPitchesForBar(barNumber))
      bar = new Bar(pitches, this.synth)
      this.bars.push(bar)
      Tone.Transport.schedule(bar.play, (barNumber - 1).toString() + ':0:0')
    }
  }

  _cantusFirmusPitchesForBar(bar) {
    let barsWithPitches = $('.sandbox__note-link--cantus-firmus').parent().toArray().filter((noteNode) => {
      return parseInt($(noteNode).data('bar')) == bar
    })
    return barsWithPitches.map((noteNode) => $(noteNode).data('pitch'))
  }

  _counterpointPitchesForBar(bar) {
    let barsWithPitches = $('.sandbox__note-link--counterpoint').parent().toArray().filter((noteNode) => {
      return parseInt($(noteNode).data('bar')) == bar
    })
    return barsWithPitches.map((noteNode) => $(noteNode).data('pitch'))
  }

  play() {
    Tone.Transport.toggle()
  }
}

class Bar {
  constructor(pitches, synth) {
    this.synth = synth
    this.pitches = pitches.map((pitch) => pitch.replace('♯', '#').replace('♭', 'b'))
    this.play = this.play.bind(this)
  }

  play(time) {
    this.synth.triggerAttackRelease(this.pitches, '1m', time)
  }
}
