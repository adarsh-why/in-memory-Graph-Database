require 'json'

@graph = []
@node_id = [0]
@edge_id = [0]

def process input
    words = input.split(' ')
    return create_node words[1] if words[0] == 'node'
    return create_edge words[1], words[2], words[3] if words[0] == 'edge'      
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

def create_edge label, from, to
    @edge_id << @edge_id.last+1
    edge = {
        id: @edge_id.last,
        name: label,
        from: from,
        to: to
    }
    mix_node_and edge
    puts "Edge '#{label}' is created"
end

def mix_node_and edge
    @graph.each do |vertex|
        if vertex[:name] == edge[:from] #or vertex[:name] == edge[:to]
            vertex[:edge] << edge
        end
    end      
end

def graph_to_json
    File.open('result.json', 'w') do |file|
        file.puts JSON.pretty_generate(@graph)
    end
    puts 'data replaced in "result.json" inside root folder' 
end

def query_mode    
    def find_relation from, relation
        result = [] 
        @graph.each do |hash|
            hash[:edge].each do |h|
                if relation == 'in'
                    result << h[:from] if from == h[:to]
                elsif relation == 'out'
                    result << h[:to] if from == h[:from]
                else  
                    result << h[:to] if (h[:name] == relation and h[:from] == from)
                end
            end
        end
        return result
    end

    puts "enter 'exit' to exit query mode"
    
    while true        
        print "query>>>  "
        input = gets.chomp
        break if input.downcase == "exit"
        
        query_array = Array.new(input.split('.'))
        from = query_array.shift
        relation = query_array.shift
        final_result = find_relation from, relation
        if query_array.empty?
            puts final_result
        else
        	query_array.each do |relation|
            final_result = find_relation final_result.last, relation
          	end
          	puts final_result
        end
    end
end

while true
    print "Graph>>> "
    input = gets.chomp
    if input.downcase == "g.show"
        puts @graph.inspect
    elsif input.downcase == "g.json"
        graph_to_json
    elsif input.downcase == "g.query"
        query_mode
    else
        process(input)
    end
end