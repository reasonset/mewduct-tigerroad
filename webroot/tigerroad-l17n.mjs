import { localizeMeta, getTitle } from "/m17n.mjs"

export function videoLocalize() {
  const videometa = JSON.parse(document.getElementById("VideoMetaJSON").textContent)
  const local_meta = localizeMeta(videometa)

  const title_elm = document.getElementById("VideoTitle")
  title_elm.textContent = local_meta.title

  const ts_elm = document.getElementById("UploadTSTime")
  const uploaded_at = new Date(videometa.created_at * 1000)
  ts_elm.textContent = uploaded_at.toLocaleString()

  const desc_elm = document.getElementById("VideoDescriptionText")
  desc_elm.value = local_meta.description || ""
}

function cardLocalize(index_meta) {
  let index = 0
  for (const elem of document.getElementsByClassName("video_card")) {
    const title = getTitle(index_meta[index])
    const title_elm = elem.getElementsByClassName("video_card_title")[0]
    title_elm.title = title
    title_elm.textContent = title

    const published_time = elem.getElementsByTagName("time")[0]
    published_time.textContent = new Date(index_meta[index].created_at * 1000).toLocaleDateString()

    index++
  }
}

export async function indexCardLocalize() {
  const index_meta = JSON.parse(document.getElementById("HomeVideosJSON").textContent)
  cardLocalize(index_meta)
}
export async function userCardLocalize() {
  const videos = JSON.parse(document.getElementById("UserVideosJSON").textContent)
  cardLocalize(videos)
}