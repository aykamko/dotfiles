if !exists('g:test#ruby#paytest#file_pattern')
  let g:test#ruby#paytest#file_pattern = 'test/.*\.rb'
endif

function! test#ruby#paytest#test_file(file) abort
  return getcwd() =~# '/pay-server$' && a:file =~# g:test#ruby#paytest#file_pattern
endfunction

function! test#ruby#paytest#build_position(type, position) abort
  if a:type == 'nearest'
    return [a:position['file'].':'.a:position['line']]
  elseif a:type == 'file'
    return [a:position['file']]
  else
    return []
  endif
endfunction

function! test#ruby#paytest#build_args(args) abort
  return a:args
endfunction

function! test#ruby#paytest#executable() abort
  return './scripts/bin/test'
endfunction
