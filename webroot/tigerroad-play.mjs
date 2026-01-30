import { videoLocalize } from "/tigerroad-l17n.mjs"
import { get } from "/http.mjs"

async function mewduct() {
  const split_path = location.pathname.split("/")
  const user_id = split_path[2]
  const media_id = split_path[3]

  const sources = await get(`/media/${user_id}/${media_id}/sources.json`)
  const usermeta = await get(`/user/${user_id}/usermeta.json`)
  
  const plyr = new Plyr("#PlyrVideo", {
    mediaMetadata: {
      title: sources.title,
      artist: usermeta.username
    }
  })
  plyr.source = sources

  if (MEWDUCT_CONFIG.player_additional_1) {
    const box = document.getElementById("PlayerAdditionalSection1")
    box.innerHTML = MEWDUCT_CONFIG.player_additional_1
  }

  if (MEWDUCT_CONFIG.player_additional_2) {
    const box = document.getElementById("PlayerAdditionalSection2")
    box.innerHTML = MEWDUCT_CONFIG.player_additional_2
  }
}

videoLocalize()
mewduct()