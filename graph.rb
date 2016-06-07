require 'json'

@graph = []
@node_id = [0]
@edge_id = [0]

def process input
    words = input.split(' ')
    return create_node words[1] if words[0] == 'node'
    return create_edge words[1], words[2].to_i, words[3].to_i if words[0] == 'edge'      
end

def create_node name
    @node_id << @node_id.last+1
    node = {
        id: @node_id.last,
        name: name,
        edge: []
    }
    @graph.push(node)
    puts "Node '#{name}' is created"
end

def create_edge label, ins, out
    @edge_id << @edge_id.last+1
    edge = {
        id: @edge_id.last,
        name: label,
        ins: [].push(ins),
        out: [].push(out)
    }
    mix_node_and edge
    puts "Edge '#{label}' is created"
end

def mix_node_and edge
    @graph.each do |vertex|
        if vertex[:id] == edge[:ins].last or vertex[:id] == edge[:out].last
            vertex[:edge] << edge
        end
    end      
end

def graph_to_json
    File.open('result.json', 'w') do |file|
        @graph.each do |line|  
            file.puts "#{line.to_json}\n"
        end      
    end
    puts 'data replaced in "result.json" inside root folder' 
end

while true
    print "Graph>>> "
    input = gets.chomp
    if input.downcase == "check graph"
        puts @graph.inspect
    elsif input.downcase == "graph to json"
        graph_to_json
    else
        process(input)
    end
end