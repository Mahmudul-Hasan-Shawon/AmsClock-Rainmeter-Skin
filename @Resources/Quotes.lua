function Initialize()

    quotes = {
        "WHAT YOU SEEK IS SEEKING YOU.",
        "THE WOUND IS THE PLACE WHERE THE LIGHT ENTERS YOU.",
        "LET YOURSELF BE SILENTLY DRAWN BY WHAT YOU REALLY LOVE.",
        "WHERE THERE IS RUIN, THERE IS HOPE FOR A TREASURE.",
        "RAISE YOUR WORDS, NOT YOUR VOICE.",
        "THE QUIETER YOU BECOME, THE MORE YOU ARE ABLE TO HEAR.",
        "THE BEAUTY YOU SEE IN ME IS A REFLECTION OF YOU.",
        "YESTERDAY I WAS CLEVER, SO I WANTED TO CHANGE THE WORLD.",
        "TODAY I AM WISE, SO I AM CHANGING MYSELF."
    }

    currentQuote = 1
    tick = 0

    -- timing (skin updates every 16 ms = 60 fps)
    ticksPerQuote = 313   -- ~5 seconds per quote
    fadeTicks     = 62    -- ~1 second fade in / fade out at 60fps

    -- layout / motion
    baseOffset = 18   -- resting Y offset below previous meter
    enterSlide = 12   -- slides up from this far below when entering
    exitSlide  = 18   -- slides up out of the top by this far when leaving
    maxAlpha   = 180  -- matches the original FontColor alpha

    -- shows or hides the quote (read from QuoteShow=1/0 in the skin)
    quoteVisible = (tostring(SKIN:GetVariable('QuoteShow', '1')) == '1')
    if quoteVisible then
        SKIN:Bang('!ShowMeter', 'MeterQuote')
    else
        SKIN:Bang('!HideMeter', 'MeterQuote')
    end

    SetText()
end


function Ease(x)
    return x * x * (3 - 2 * x)
end


function Update()

    -- read the on/off toggle live so it works without a refresh
    if (tostring(SKIN:GetVariable('QuoteShow', '1')) == '1') ~= quoteVisible then
        quoteVisible = not quoteVisible
        if quoteVisible then
            SKIN:Bang('!ShowMeter', 'MeterQuote')
        else
            SKIN:Bang('!HideMeter', 'MeterQuote')
        end
    end

    tick = tick + 1

    if tick >= ticksPerQuote then
        tick = 0
        currentQuote = currentQuote + 1
        if currentQuote > #quotes then
            currentQuote = 1
        end
        SetText()
    end

    local alpha
    local y

    if tick < fadeTicks then
        -- fade in, sliding up into place from below
        local e = Ease(tick / fadeTicks)
        alpha = math.floor(maxAlpha * e)
        y = math.floor(baseOffset + enterSlide * (1 - e) + 0.5)
    elseif tick > ticksPerQuote - fadeTicks then
        -- fade out, sliding up through the top
        local e = Ease((ticksPerQuote - tick) / fadeTicks)
        alpha = math.floor(maxAlpha * e)
        y = math.floor(baseOffset - exitSlide * (1 - e) + 0.5)
    else
        alpha = maxAlpha
        y = baseOffset
    end

    SKIN:Bang("!SetOption", "MeterQuote", "FontColor", "255,255,255," .. alpha)
    SKIN:Bang("!SetOption", "MeterQuote", "Y", y .. "R")
    SKIN:Bang("!UpdateMeter", "MeterQuote")
    SKIN:Bang("!Redraw")

    return currentQuote
end


function SetText()
    SKIN:Bang("!SetOption", "MeterQuote", "Text", quotes[currentQuote])
end