if exists("g:neovide")
  let g:neovide_transparency = 0.85
  let g:neovide_scroll_animation_length = 0.35
  let g:neovide_scroll_animation_far_lines = 1
  let g:neovide_hide_mouse_when_typing = v:true
  let g:neovide_underline_stroke_scale = 1.0
  let g:neovide_fullscreen = v:false
  let g:neovide_profiler = v:false


  " Cursor settings
  let g:neovide_cursor_animation_length = 0.2
  let g:neovide_cursor_trail_size = 0.6
  let g:neovide_cursor_antialiasing = v:true
  let g:neovide_cursor_unfocused_outline_width = 0.05

  let g:neovide_cursor_styles = [ "", "railgun", "torpedo", "pixiedust", "sonicboom", "ripple", "wireframe" ]
  let g:neovide_cursor_vfx_mode = "railgun"
  let g:neovide_cursor_vfx_opacity = 200.0
  let g:neovide_cursor_vfx_particle_curl = 1.0
  let g:neovide_cursor_vfx_particle_density = 7.0
  let g:neovide_cursor_vfx_particle_lifetime = 2.2
  let g:neovide_cursor_vfx_particle_phase = 3.5
  let g:neovide_cursor_vfx_particle_speed = 10.0

  " toggle profiler
  nnoremap <space>pf <cmd>let g:neovide_profiler = g:neovide_profiler == v:true ? v:false : v:true<cr>

  command Transparency call <SID>transparency()

  function s:transparency()
    echo "Press '+', '-' to increase/decrease the opacity respectively, or 'q' to quit"
    let char = ''
    while char != 'q'
      let input = getchar()
      let char = nr2char(input)
      if char == '+'
	let g:neovide_transparency = g:neovide_transparency + 0.05
      elseif char == '-'
	let g:neovide_transparency = g:neovide_transparency - 0.05
      endif
    endwhile
    echo "New transparency value is at: " .. printf("%f", g:neovide_transparency)
  endfunction

  function s:changeScale(delta)
    let g:neovide_scale_factor = g:neovide_scale_factor + a:delta
  endfunction

  nunmap <C-=>
  nunmap <C-->
  nnoremap <C-=> <cmd>call <SID>changeScale(0.05)<cr>
  nnoremap <C--> <cmd>call <SID>changeScale(-0.05)<cr>

endif
