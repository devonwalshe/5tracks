import { helper } from '@ember/component/helper';

export function paginationCount(params,hash) {
  let [model, data, page, size] = params;
  let pages = data.meta.pages;
  let end = page * size;
  let start = end - size + 1
  let total = data.meta.total;
  if(end >= total){
    start = (page*size)-size + 1
    end = total
  }
  
  return `Showing ${model}s ${start} to ${end} of ${total}`
  
  // let page = page
  // let total = model.meta.total
  // console.log(len, page, total)
  // return `Page ${page} of ${pages}`;
}

export default helper(paginationCount);
