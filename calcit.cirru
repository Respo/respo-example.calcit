
{}
  :about "|Machine-generated snapshot. Do not edit directly — changes will be overwritten. Use `calcit query` to inspect and `calcit edit`/`calcit tree` to modify. Run `calcit docs agents --contract` before mutations; use `--full` for first orientation or changed contract digest. Manual edits must follow format and schema conventions, then run `calcit edit format`."
  :package |app
  :entries $ {} $ :default
    {} (:description |Browser-example) (:init-fn 'app.main/main!) (:mode :js) (:reload-fn 'app.main/reload!)
      :feature-policy $ {}
      :modules $ [] |respo.calcit/ |respo-ui.calcit/ |js-ffi/
      :type-slots $ {}
  :files $ {}
    'app.comp.container $ %{} 'FileEntry
      :defs $ {}
        'comp-container $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-container (store)
            let
                states $ :states store
                cursor $ decode-map-as
                  option:unwrap-or (get states :cursor) ([])
                  :: 'List 'Dynamic
                state $ decode-map-as
                  option:unwrap-or (get states :data)
                    {} $ :content |
                  :: 'Map 'Tag 'String
                log-plugin $ use-log
                  decode-map-as (>> states :cont) (:: 'Map 'Tag 'Dynamic)
                  option:unwrap $ get state :content
              [] (:effect log-plugin)
                div
                  {} $ :style $ merge ui/global ui/column
                    {} $ :padding |8px
                  div ({})
                    input $ {}
                      :value $ option:unwrap $ get state :content
                      :placeholder |Content
                      :style $ merge ui/expand ui/input
                      :on-input $ fn (e d!)
                        hint-fn $ {} (:return 'Unit)
                          :args $ [] (:: 'Map 'Tag 'Dynamic) 'Dynamic
                        let
                            value $ .unwrap $ get e :value
                          when (string? value)
                            d! $ :: :states cursor $ assoc state :content value
                        , &unit
                    =< 8 nil
                    button $ {} (:style ui/button) (:inner-text |Run)
                      :on-click $ fn (e d!)
                        println $ option:unwrap $ get state :content
                    =< 24 nil
                    <> $ str "|Counter: " $ :counter store
                    =< 8 nil
                    button $ {} (:style ui/button) (:inner-text "|Inc counter")
                      :on-click $ fn (e d!)
                        d! $ :: :inc nil
                  =< nil 16
                  memo-comp-by :a comp-demo
                    decode-map-as (>> states :a) (:: 'Map 'Tag 'Dynamic)
                    , |A 10
                  memo-comp-by :a2 comp-demo
                    decode-map-as (>> states :a2) (:: 'Map 'Tag 'Dynamic)
                    , |A2 10
                  memo-comp-by :a3 comp-demo
                    decode-map-as (>> states :a3) (:: 'Map 'Tag 'Dynamic)
                    , |A3 10
                  memo-comp-by :a4 comp-demo
                    decode-map-as (>> states :a4) (:: 'Map 'Tag 'Dynamic)
                    , |A4 10
                  memo-comp-by :a5 comp-demo
                    decode-map-as (>> states :a5) (:: 'Map 'Tag 'Dynamic)
                    , |A5 10
                  :ui log-plugin
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] 'app.schema/Store
        'comp-demo $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defcomp comp-demo (states mark level)
            let
                cursor $ decode-map-as
                  option:unwrap $ get states :cursor
                  :: 'List 'Dynamic
                state $ decode-map-as
                  option:unwrap-or (get states :data)
                    {} $ :draft |
                  :: 'Map 'Tag 'String
                log-plugin $ let
                    cached-plugin $ memo-value-by cursor use-log
                      decode-map-as (>> states :demo) (:: 'Map 'Tag 'Dynamic)
                      , |DEMO
                  if (struct? cached-plugin)
                    struct-match cached-plugin (LogPlugin plugin plugin)
                      _ invalid $ raise |Expected-LogPlugin
                    raise |Expected-LogPlugin
              println |Called: mark
              [] (:effect log-plugin)
                div
                  {} $ :style $ {}
                    :border $ str "|1px solid " $ hsl 0 0 90
                    :padding 8
                  input $ {}
                    :value $ option:unwrap $ get state :draft
                    :style ui/input
                    :on-input $ fn (e d!)
                      hint-fn $ {} (:return 'Unit)
                        :args $ [] (:: 'Map 'Tag 'Dynamic) 'Dynamic
                      let
                          value $ .unwrap $ get e :value
                        when (string? value)
                          d! $ :: :states cursor $ assoc state :draft value
                      , &unit
                  <> $ str "|This is a demo: " mark
                  pre $ {}
                    :style $ {}
                      :background $ hsl 0 0 95
                      :padding "|4px 8px"
                    :inner-text $ trim $ format-cirru-edn state
                  ; if (> level 10)
                    comp-demo
                      decode-map-as (>> states level) (:: 'Map 'Tag 'Dynamic)
                      str |M- level
                      dec level
                  :ui log-plugin
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Component)
            :args $ [] (:: 'Map 'Tag 'Dynamic) 'String 'Number
        'effect-log $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defeffect effect-log (mark) (action el at?)
            js-ffi.browser/console-log! $ str-spaced "|Effect happen:" mark action
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Effect)
            :args $ [] 'String
            :features $ #{} :js-ffi
          :tests $ [] $ %{} 'TestEntry (:name |constructs-typed-effect)
            :code $ quote $ assert= :effect-log
              :name $ effect-log |demo
        'use-log $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn use-log (states mark)
            let
                cursor $ decode-map-as
                  option:unwrap $ get states :cursor
                  :: 'List 'Dynamic
                state $ decode-map-as
                  option:unwrap-or (get states :data)
                    {} $ :draft |
                  :: 'Map 'Tag 'String
              LogPlugin :ui
                div ({})
                  <> $ str "|LOG ::: " mark "| :: " $ option:unwrap (get state :draft)
                  input $ {}
                    :value $ option:unwrap $ get state :draft
                    :style ui/input
                    :on-input $ fn (e d!)
                      hint-fn $ {} (:return 'Unit)
                        :args $ [] (:: 'Map 'Tag 'Dynamic) 'Dynamic
                      let
                          value $ .unwrap $ get e :value
                        when (string? value)
                          d! $ :: :states cursor $ assoc state :draft value
                      , &unit
                , :effect $ effect-log mark
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/LogPlugin)
            :args $ [] (:: 'Map 'Tag 'Dynamic) 'String
        'use-plugin $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn use-plugin (mark)
            div
              {} $ :style $ {}
                :border $ str "|1px solid " $ hsl 0 0 93
              <> $ str "|log ::: " mark
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.schema/Element)
            :args $ [] 'String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.comp.container
          :require (respo-ui.core :as ui)
            respo.core :refer $ defcomp defeffect <> >> div button textarea span input pre memo-comp-by memo-value-by
            respo.comp.space :refer $ =<
            app.config :refer $ dev?
            respo.util.format :refer $ hsl
            app.schema :refer $ LogPlugin
    'app.config $ %{} 'FileEntry
      :defs $ {}
        'dev? $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def dev? true
          :examples $ []
          :schema $ :: 'Bool
        'site $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def site
            {} $ :storage-key |workflow
          :examples $ []
          :schema $ :: 'Map 'Tag 'String
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.config
    'app.main $ %{} 'FileEntry
      :defs $ {}
        '*store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defref *store schema/store
          :examples $ []
          :schema $ :: 'Ref 'app.schema/Store
        'dispatch! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn dispatch! (op)
            when config/dev? $ println |Dispatch: op
            reset! *store $ updater @*store op
            , &unit
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ [] 'Dynamic
        'main! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn main! () (load-console-formatter!)
            println "|Running mode:" $ if config/dev? |dev |release
            render-app!
            add-watch! *store :changes $ fn (store prev) (render-app!)
            println "|App started."
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
            :features $ #{} :js-ffi
        'mount-target $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn mount-target ()
            match (js-ffi.browser/query-selector |.app)
              (:none) (raise "|Missing .app mount target")
              (:some host) (respo.ffi.browser/narrow-element host)
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'respo.dom/DomElement)
            :args $ []
            :features $ #{} :js-ffi
        'reload! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn reload! () (clear-cache!) (remove-watch! *store :changes)
            add-watch! *store :changes $ fn (store prev) (render-app!)
            render-app!
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
        'render-app! $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defn render-app! ()
            render-with! (mount-target)
              fn () $ dbg $ comp-container @*store
              , dispatch!
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'Unit)
            :args $ []
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.main
          :require
            respo.core :refer $ render-with! clear-cache!
            app.comp.container :refer $ comp-container
            app.updater :refer $ updater
            app.schema :as schema
            app.config :as config
    'app.schema $ %{} 'FileEntry
      :defs $ {}
        'LogPlugin $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct LogPlugin (:ui 'respo.schema/Element) (:effect 'respo.schema/Effect)
          :examples $ []
          :schema $ :: 'StructDef
        'Store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ defstruct Store
            :states $ :: 'Map 'Tag 'Dynamic
            :counter 'Number
          :examples $ []
          :schema $ :: 'StructDef
        'store $ %{} 'CodeEntry (:doc |)
          :code $ quote $ def store
            Store :states
              {} $ :cursor $ []
              , :counter 0
          :examples $ []
          :schema $ :: 'app.schema/Store
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.schema
    'app.updater $ %{} 'FileEntry
      :defs $ {} $ 'updater
        %{} 'CodeEntry (:doc |)
          :code $ quote $ defn updater (store op)
            if (enum? op)
              match op
                (:states cursor data)
                  assoc store :states $ decode-map-as
                    update-state-tree (:states store)
                      decode-map-as cursor $ :: 'List 'Dynamic
                      , data
                    :: 'Map 'Tag 'Dynamic
                (:inc _)
                  assoc store :counter $ inc $ :counter store
                _ store
              , store
          :examples $ []
          :schema $ :: 'Fn $ {} (:return 'app.schema/Store)
            :args $ [] 'app.schema/Store 'Dynamic
      :ns $ %{} 'NsEntry (:doc |)
        :code $ quote $ ns app.updater
          :require $ respo.cursor :refer $ update-state-tree
