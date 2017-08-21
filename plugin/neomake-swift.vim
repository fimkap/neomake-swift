
" Swift maker.
let swift_dic = {}

if filereadable('.neomake_swift')
    let lines = readfile('.neomake_swift')
    for line in lines
        let len = strlen(line)
        let eq_position = match(line, '=')
        let key = strpart(line, 0, eq_position)
        let value = strpart(line, eq_position+1, len)
        let swift_dic[key] = value
    endfor
endif

if !has_key(swift_dic, 'sdk')
    let swift_dic['sdk'] = system('xcrun --show-sdk-path')
endif

let swift_args = ['-frontend','-c'] + (has_key(swift_dic,'files') ?  split(expand(swift_dic['files'])) : []) + ['-sdk'] + split(swift_dic['sdk']) + (has_key(swift_dic,'target') ? ['-target'] + split(swift_dic['target']) : []) + ['-primary-file']

let g:neomake_swift_swiftc_maker = {
        \ 'exe' : 'swift',
        \ 'args': swift_args,
        \ 'errorformat':
            \ '%E%f:%l:%c: error: %m,' .
            \ '%W%f:%l:%c: warning: %m,' .
            \ '%Z%\s%#^~%#,' .
            \ '%-G%.%#',
        \ }

let g:neomake_swift_enabled_makers = ['swiftc']
autocmd! BufWritePost *.swift Neomake
