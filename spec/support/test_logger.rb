class TestLogger
  def close
    @closed = true
  end

  def flush
    @flushed = true
  end

  def add(*args)
    messages.push args
  end

  def messages
    @messages ||= [ ]
    @messages
  end

  def flushed?; !!@flushed end
  def closed?; !!@closed end
end
