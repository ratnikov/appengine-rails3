class TestLogger
  include Logger::Severity

  def close
    @closed = true
  end

  def flush
    @flushed = true
  end

  def add(*args)
    messages.push args
  end

  Logger::Severity.constants.each do |konst|
    class_eval <<-EVAL, __FILE__, __LINE__
    def #{konst.downcase}(message)
      add #{konst}, message
    end
    EVAL
  end

  def messages
    @messages ||= [ ]

    @messages
  end

  def flushed?; !!@flushed end
  def closed?; !!@closed end

  private

  def method_missing(name, *args)
    if name.to_s =~ /^(.*)s$/ && (level = ::Logger::Severity.const_get($1.upcase))
      messages.map { |msg_level, message| message if msg_level >= level }.compact
    else
      super
    end
  end
end
