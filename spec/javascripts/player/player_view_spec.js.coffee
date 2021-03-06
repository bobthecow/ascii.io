describe 'AsciiIo.PlayerView', ->
  element = null
  cols = 2
  lines = 5
  data = ''
  timing = []

  beforeEach ->
    element = $('<div>')

  describe 'constructor', ->
    it 'creates needed DOM elements inside player element', ->
      player = new AsciiIo.PlayerView({
        el: element, cols: cols, lines: lines, data: data, timing: timing
      })

      expect(element.find('.terminal').length).toBe(1)
      expect(element.find('.hud').length).toBe(1)

    it 'creates TerminalView instance passing proper DOM element', ->
      spyOn(AsciiIo, 'TerminalView').andReturn(
        on: -> 'foo',
        render: -> undefined,
        afterInsertedToDom: -> undefined
      )

      player = new AsciiIo.PlayerView({
        cols: cols, lines: lines, data: data, timing: timing
      })

      expect(AsciiIo.TerminalView).toHaveBeenCalledWith({
        cols: cols, lines: lines
      })

    it 'creates HudView instance passing proper DOM element', ->
      spyOn(AsciiIo, 'HudView').andReturn({ on: -> 'foo' })

      player = new AsciiIo.PlayerView({
        el: element, cols: cols, lines: lines, data: data, timing: timing
      })

      expect(AsciiIo.HudView).toHaveBeenCalled()

    it 'creates Movie instance', ->
      spyOn(AsciiIo, 'Movie').andCallThrough()

      player = new AsciiIo.PlayerView({
        el: element, cols: cols, lines: lines, data: data, timing: timing
      })

      expect(AsciiIo.Movie).toHaveBeenCalledWith(data, timing)

  describe 'events', ->
    player = null

    beforeEach ->
      player = new AsciiIo.PlayerView({
        el: element, cols: cols, lines: lines, data: data, timing: timing
      })

    it 'toggles movie playback when terminal-click is fired on terminal', ->
      spyOn player.movie, 'togglePlay'

      player.terminalView.trigger 'terminal-click'

      expect(player.movie.togglePlay).toHaveBeenCalled()

    it 'toggles movie playback when hud-play-click is fired on hud', ->
      spyOn player.movie, 'togglePlay'

      player.hudView.trigger 'hud-play-click'

      expect(player.movie.togglePlay).toHaveBeenCalled()

    it 'seeks movie playback when hud-seek-click is fired on hud', ->
      spyOn player.movie, 'seek'

      player.hudView.trigger 'hud-seek-click', 55

      expect(player.movie.seek).toHaveBeenCalledWith(55)

    it 'toggles fullscreen view when hud-fullscreen-click is fired on hud', ->
      # pending functionality

    it 'stops cursor blinking when movie-finished is fired on movie', ->
      spyOn player.terminalView, 'stopCursorBlink'

      player.movie.trigger 'movie-finished'

      expect(player.terminalView.stopCursorBlink).toHaveBeenCalled()

    it 'feeds interpreter when movie-frame is fired on movie', ->
      frame = { some: 'Frame' }
      spyOn player.vt, 'feed'

      player.movie.trigger 'movie-frame', frame

      expect(player.vt.feed).toHaveBeenCalledWith(frame)

  describe '#play', ->
    it 'starts movie playback', ->
      player = new AsciiIo.PlayerView({
        el: element, cols: cols, lines: lines, data: data, timing: timing
      })
      spyOn player.movie, 'play'

      player.play()

      expect(player.movie.play).toHaveBeenCalled()
