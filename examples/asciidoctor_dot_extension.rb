class DotBlock < Asciidoctor::Extensions::BlockProcessor
  COLORS = {
    NODE: '#a8e270',
    NODE2: '#95bbe3',
    EDGE: '#a40000'
  }

  use_dsl
  named :dot
  on_context :listing
  parse_content_as :raw
  def process parent, reader, attrs
    settings = %(node [shape="box", penwidth="1.5", fillcolor="#fadcad", color="#2e3436", style="filled,rounded", fontcolor="#1c2021", fontsize=12, fontname="Arial"]
edge [color="#2e3436", penwidth=2, arrowhead="vee", arrowtail="vee", arrowsize=0.75, fontcolor="#1c2021", fontsize=12, fontname="Arial"]
nodesep=0.4)
    source = reader.read.gsub(/([A-Z]+[0-9]?)HIGHLIGHT/) {
      COLORS[$~[1]] 
    }
    graph_data = %(digraph g {\n#{settings}\n#{source}\n})
    title = (value = attrs['title']) ? %(\n<div class="title">#{value}</div>) : nil
    rendered = <<-EOS
<div class="imageblock">
<div class="content">
<script type="text/vnd.graphviz" class="dotdiagram">
#{graph_data}
</script>
</div>#{title}
</div>
    EOS
    create_pass_block parent, rendered, attrs, :subs => nil
  end
end

Asciidoctor::Extensions.register do
  block DotBlock
end
