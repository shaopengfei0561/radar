function val=crc(data)
    val=data(1);
    for i=2:length(data)
        val=bitxor(data(i),val);
    end
end