using JSServe, Observables
using JSServe: @js_str, onjs, Slider, Session, App
using JSServe.DOM
using Hyperscript
using WGLMakie
using ColorSchemes
app = App() do session::Session
    n = 100
    potar = Slider(1:n)
    fig = Figure()
    x=LinRange(0.,1.,n)
    #w = map(potar) do idx
    #  return  Float32.(x*x'.<=(idx / n))
    #end
    ax, hm = heatmap(fig[1,1], Float32.(x*x'.<=(5. / n)) , colormap=:jet)
    on(potar.value) do idx
        hm[3][] = Float32.(x*x'.<=(idx / n))
    end
    slider = DOM.div("z-index: ", potar, potar.value)
    return JSServe.record_states(session, DOM.div(slider, fig))
end


if isdefined(Main, :server)
    close(server)
end

server = JSServe.Server(app, "127.0.0.1", 8082)
JSServe.HTTPServer.start(server)
wait(server)
