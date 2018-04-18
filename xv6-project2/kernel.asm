
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc b0 b5 10 80       	mov    $0x8010b5b0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 30 2a 10 80       	mov    $0x80102a30,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	53                   	push   %ebx
80100038:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003b:	c7 44 24 04 20 6c 10 	movl   $0x80106c20,0x4(%esp)
80100042:	80 
80100043:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010004a:	e8 69 3b 00 00       	call   80103bb8 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100056:	fc 10 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100060:	fc 10 80 
80100063:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100068:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
8010006d:	eb 03                	jmp    80100072 <binit+0x3e>
8010006f:	90                   	nop
80100070:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
80100072:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
80100075:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
8010007c:	c7 44 24 04 27 6c 10 	movl   $0x80106c27,0x4(%esp)
80100083:	80 
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
80100087:	89 04 24             	mov    %eax,(%esp)
8010008a:	e8 39 3a 00 00       	call   80103ac8 <initsleeplock>
    bcache.head.next->prev = b;
8010008f:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100094:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100097:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009d:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000a3:	89 da                	mov    %ebx,%edx
801000a5:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
801000aa:	75 c4                	jne    80100070 <binit+0x3c>
  }
}
801000ac:	83 c4 14             	add    $0x14,%esp
801000af:	5b                   	pop    %ebx
801000b0:	5d                   	pop    %ebp
801000b1:	c3                   	ret    
801000b2:	66 90                	xchg   %ax,%ax

801000b4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000b4:	55                   	push   %ebp
801000b5:	89 e5                	mov    %esp,%ebp
801000b7:	57                   	push   %edi
801000b8:	56                   	push   %esi
801000b9:	53                   	push   %ebx
801000ba:	83 ec 1c             	sub    $0x1c,%esp
801000bd:	8b 75 08             	mov    0x8(%ebp),%esi
801000c0:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000c3:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801000ca:	e8 b1 3b 00 00       	call   80103c80 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000cf:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000d5:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000db:	75 0e                	jne    801000eb <bread+0x37>
801000dd:	eb 1d                	jmp    801000fc <bread+0x48>
801000df:	90                   	nop
801000e0:	8b 5b 54             	mov    0x54(%ebx),%ebx
801000e3:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000e9:	74 11                	je     801000fc <bread+0x48>
    if(b->dev == dev && b->blockno == blockno){
801000eb:	3b 73 04             	cmp    0x4(%ebx),%esi
801000ee:	75 f0                	jne    801000e0 <bread+0x2c>
801000f0:	3b 7b 08             	cmp    0x8(%ebx),%edi
801000f3:	75 eb                	jne    801000e0 <bread+0x2c>
      b->refcnt++;
801000f5:	ff 43 4c             	incl   0x4c(%ebx)
801000f8:	eb 3c                	jmp    80100136 <bread+0x82>
801000fa:	66 90                	xchg   %ax,%ax
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
801000fc:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100102:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100108:	75 0d                	jne    80100117 <bread+0x63>
8010010a:	eb 58                	jmp    80100164 <bread+0xb0>
8010010c:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010010f:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100115:	74 4d                	je     80100164 <bread+0xb0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
80100117:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010011a:	85 c0                	test   %eax,%eax
8010011c:	75 ee                	jne    8010010c <bread+0x58>
8010011e:	f6 03 04             	testb  $0x4,(%ebx)
80100121:	75 e9                	jne    8010010c <bread+0x58>
      b->dev = dev;
80100123:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
80100126:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
80100129:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
8010012f:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100136:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010013d:	e8 fa 3b 00 00       	call   80103d3c <release>
      acquiresleep(&b->lock);
80100142:	8d 43 0c             	lea    0xc(%ebx),%eax
80100145:	89 04 24             	mov    %eax,(%esp)
80100148:	e8 b3 39 00 00       	call   80103b00 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
8010014d:	f6 03 02             	testb  $0x2,(%ebx)
80100150:	75 08                	jne    8010015a <bread+0xa6>
    iderw(b);
80100152:	89 1c 24             	mov    %ebx,(%esp)
80100155:	e8 a2 1d 00 00       	call   80101efc <iderw>
  }
  return b;
}
8010015a:	89 d8                	mov    %ebx,%eax
8010015c:	83 c4 1c             	add    $0x1c,%esp
8010015f:	5b                   	pop    %ebx
80100160:	5e                   	pop    %esi
80100161:	5f                   	pop    %edi
80100162:	5d                   	pop    %ebp
80100163:	c3                   	ret    
  panic("bget: no buffers");
80100164:	c7 04 24 2e 6c 10 80 	movl   $0x80106c2e,(%esp)
8010016b:	e8 a0 01 00 00       	call   80100310 <panic>

80100170 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100170:	55                   	push   %ebp
80100171:	89 e5                	mov    %esp,%ebp
80100173:	53                   	push   %ebx
80100174:	83 ec 14             	sub    $0x14,%esp
80100177:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
8010017a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010017d:	89 04 24             	mov    %eax,(%esp)
80100180:	e8 07 3a 00 00       	call   80103b8c <holdingsleep>
80100185:	85 c0                	test   %eax,%eax
80100187:	74 10                	je     80100199 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
80100189:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
8010018c:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010018f:	83 c4 14             	add    $0x14,%esp
80100192:	5b                   	pop    %ebx
80100193:	5d                   	pop    %ebp
  iderw(b);
80100194:	e9 63 1d 00 00       	jmp    80101efc <iderw>
    panic("bwrite");
80100199:	c7 04 24 3f 6c 10 80 	movl   $0x80106c3f,(%esp)
801001a0:	e8 6b 01 00 00       	call   80100310 <panic>
801001a5:	8d 76 00             	lea    0x0(%esi),%esi

801001a8 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001a8:	55                   	push   %ebp
801001a9:	89 e5                	mov    %esp,%ebp
801001ab:	56                   	push   %esi
801001ac:	53                   	push   %ebx
801001ad:	83 ec 10             	sub    $0x10,%esp
801001b0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001b3:	8d 73 0c             	lea    0xc(%ebx),%esi
801001b6:	89 34 24             	mov    %esi,(%esp)
801001b9:	e8 ce 39 00 00       	call   80103b8c <holdingsleep>
801001be:	85 c0                	test   %eax,%eax
801001c0:	74 5a                	je     8010021c <brelse+0x74>
    panic("brelse");

  releasesleep(&b->lock);
801001c2:	89 34 24             	mov    %esi,(%esp)
801001c5:	e8 86 39 00 00       	call   80103b50 <releasesleep>

  acquire(&bcache.lock);
801001ca:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801001d1:	e8 aa 3a 00 00       	call   80103c80 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
801001d6:	ff 4b 4c             	decl   0x4c(%ebx)
801001d9:	75 2f                	jne    8010020a <brelse+0x62>
    // no one is waiting for it.
    b->next->prev = b->prev;
801001db:	8b 43 54             	mov    0x54(%ebx),%eax
801001de:	8b 53 50             	mov    0x50(%ebx),%edx
801001e1:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
801001e4:	8b 43 50             	mov    0x50(%ebx),%eax
801001e7:	8b 53 54             	mov    0x54(%ebx),%edx
801001ea:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
801001ed:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801001f2:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
801001f5:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    bcache.head.next->prev = b;
801001fc:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100201:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100204:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
8010020a:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
80100211:	83 c4 10             	add    $0x10,%esp
80100214:	5b                   	pop    %ebx
80100215:	5e                   	pop    %esi
80100216:	5d                   	pop    %ebp
  release(&bcache.lock);
80100217:	e9 20 3b 00 00       	jmp    80103d3c <release>
    panic("brelse");
8010021c:	c7 04 24 46 6c 10 80 	movl   $0x80106c46,(%esp)
80100223:	e8 e8 00 00 00       	call   80100310 <panic>

80100228 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100228:	55                   	push   %ebp
80100229:	89 e5                	mov    %esp,%ebp
8010022b:	57                   	push   %edi
8010022c:	56                   	push   %esi
8010022d:	53                   	push   %ebx
8010022e:	83 ec 1c             	sub    $0x1c,%esp
80100231:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
80100234:	8b 55 08             	mov    0x8(%ebp),%edx
80100237:	89 14 24             	mov    %edx,(%esp)
8010023a:	e8 e1 13 00 00       	call   80101620 <iunlock>
  target = n;
  acquire(&cons.lock);
8010023f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100246:	e8 35 3a 00 00       	call   80103c80 <acquire>
  while(n > 0){
8010024b:	89 de                	mov    %ebx,%esi
8010024d:	85 db                	test   %ebx,%ebx
8010024f:	7f 27                	jg     80100278 <consoleread+0x50>
80100251:	e9 b6 00 00 00       	jmp    8010030c <consoleread+0xe4>
80100256:	66 90                	xchg   %ax,%ax
    while(input.r == input.w){
      if(myproc()->killed){
80100258:	e8 33 30 00 00       	call   80103290 <myproc>
8010025d:	8b 40 24             	mov    0x24(%eax),%eax
80100260:	85 c0                	test   %eax,%eax
80100262:	75 74                	jne    801002d8 <consoleread+0xb0>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
80100264:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
8010026b:	80 
8010026c:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
80100273:	e8 44 35 00 00       	call   801037bc <sleep>
    while(input.r == input.w){
80100278:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
8010027e:	3b 15 a4 ff 10 80    	cmp    0x8010ffa4,%edx
80100284:	74 d2                	je     80100258 <consoleread+0x30>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100286:	89 d0                	mov    %edx,%eax
80100288:	83 e0 7f             	and    $0x7f,%eax
8010028b:	8a 80 20 ff 10 80    	mov    -0x7fef00e0(%eax),%al
80100291:	0f be c8             	movsbl %al,%ecx
80100294:	8d 7a 01             	lea    0x1(%edx),%edi
80100297:	89 3d a0 ff 10 80    	mov    %edi,0x8010ffa0
    if(c == C('D')){  // EOF
8010029d:	83 f9 04             	cmp    $0x4,%ecx
801002a0:	74 5c                	je     801002fe <consoleread+0xd6>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002a2:	8b 55 0c             	mov    0xc(%ebp),%edx
801002a5:	88 02                	mov    %al,(%edx)
801002a7:	42                   	inc    %edx
801002a8:	89 55 0c             	mov    %edx,0xc(%ebp)
    --n;
801002ab:	4e                   	dec    %esi
    if(c == '\n')
801002ac:	83 f9 0a             	cmp    $0xa,%ecx
801002af:	74 57                	je     80100308 <consoleread+0xe0>
  while(n > 0){
801002b1:	85 f6                	test   %esi,%esi
801002b3:	75 c3                	jne    80100278 <consoleread+0x50>
      break;
  }
  release(&cons.lock);
801002b5:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002bc:	e8 7b 3a 00 00       	call   80103d3c <release>
  ilock(ip);
801002c1:	8b 55 08             	mov    0x8(%ebp),%edx
801002c4:	89 14 24             	mov    %edx,(%esp)
801002c7:	e8 84 12 00 00       	call   80101550 <ilock>

  return target - n;
}
801002cc:	89 d8                	mov    %ebx,%eax
801002ce:	83 c4 1c             	add    $0x1c,%esp
801002d1:	5b                   	pop    %ebx
801002d2:	5e                   	pop    %esi
801002d3:	5f                   	pop    %edi
801002d4:	5d                   	pop    %ebp
801002d5:	c3                   	ret    
801002d6:	66 90                	xchg   %ax,%ax
        release(&cons.lock);
801002d8:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801002df:	e8 58 3a 00 00       	call   80103d3c <release>
        ilock(ip);
801002e4:	8b 55 08             	mov    0x8(%ebp),%edx
801002e7:	89 14 24             	mov    %edx,(%esp)
801002ea:	e8 61 12 00 00       	call   80101550 <ilock>
        return -1;
801002ef:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801002f4:	89 d8                	mov    %ebx,%eax
801002f6:	83 c4 1c             	add    $0x1c,%esp
801002f9:	5b                   	pop    %ebx
801002fa:	5e                   	pop    %esi
801002fb:	5f                   	pop    %edi
801002fc:	5d                   	pop    %ebp
801002fd:	c3                   	ret    
      if(n < target){
801002fe:	39 f3                	cmp    %esi,%ebx
80100300:	76 06                	jbe    80100308 <consoleread+0xe0>
        input.r--;
80100302:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
80100308:	29 f3                	sub    %esi,%ebx
8010030a:	eb a9                	jmp    801002b5 <consoleread+0x8d>
  while(n > 0){
8010030c:	31 db                	xor    %ebx,%ebx
8010030e:	eb a5                	jmp    801002b5 <consoleread+0x8d>

80100310 <panic>:
{
80100310:	55                   	push   %ebp
80100311:	89 e5                	mov    %esp,%ebp
80100313:	56                   	push   %esi
80100314:	53                   	push   %ebx
80100315:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100318:	fa                   	cli    
  cons.locking = 0;
80100319:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100320:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
80100323:	e8 38 21 00 00       	call   80102460 <lapicid>
80100328:	89 44 24 04          	mov    %eax,0x4(%esp)
8010032c:	c7 04 24 4d 6c 10 80 	movl   $0x80106c4d,(%esp)
80100333:	e8 7c 02 00 00       	call   801005b4 <cprintf>
  cprintf(s);
80100338:	8b 45 08             	mov    0x8(%ebp),%eax
8010033b:	89 04 24             	mov    %eax,(%esp)
8010033e:	e8 71 02 00 00       	call   801005b4 <cprintf>
  cprintf("\n");
80100343:	c7 04 24 8b 75 10 80 	movl   $0x8010758b,(%esp)
8010034a:	e8 65 02 00 00       	call   801005b4 <cprintf>
  getcallerpcs(&s, pcs);
8010034f:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100352:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100356:	8d 45 08             	lea    0x8(%ebp),%eax
80100359:	89 04 24             	mov    %eax,(%esp)
8010035c:	e8 73 38 00 00       	call   80103bd4 <getcallerpcs>
panic(char *s)
80100361:	8d 75 f8             	lea    -0x8(%ebp),%esi
    cprintf(" %p", pcs[i]);
80100364:	8b 03                	mov    (%ebx),%eax
80100366:	89 44 24 04          	mov    %eax,0x4(%esp)
8010036a:	c7 04 24 61 6c 10 80 	movl   $0x80106c61,(%esp)
80100371:	e8 3e 02 00 00       	call   801005b4 <cprintf>
80100376:	83 c3 04             	add    $0x4,%ebx
  for(i=0; i<10; i++)
80100379:	39 f3                	cmp    %esi,%ebx
8010037b:	75 e7                	jne    80100364 <panic+0x54>
  panicked = 1; // freeze other CPU
8010037d:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
80100384:	00 00 00 
80100387:	eb fe                	jmp    80100387 <panic+0x77>
80100389:	8d 76 00             	lea    0x0(%esi),%esi

8010038c <consputc>:
  if(panicked){
8010038c:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
80100392:	85 d2                	test   %edx,%edx
80100394:	74 06                	je     8010039c <consputc+0x10>
80100396:	fa                   	cli    
80100397:	eb fe                	jmp    80100397 <consputc+0xb>
80100399:	8d 76 00             	lea    0x0(%esi),%esi
{
8010039c:	55                   	push   %ebp
8010039d:	89 e5                	mov    %esp,%ebp
8010039f:	57                   	push   %edi
801003a0:	56                   	push   %esi
801003a1:	53                   	push   %ebx
801003a2:	83 ec 1c             	sub    $0x1c,%esp
801003a5:	89 c6                	mov    %eax,%esi
  if(c == BACKSPACE){
801003a7:	3d 00 01 00 00       	cmp    $0x100,%eax
801003ac:	0f 84 a1 00 00 00    	je     80100453 <consputc+0xc7>
    uartputc(c);
801003b2:	89 04 24             	mov    %eax,(%esp)
801003b5:	e8 4a 4d 00 00       	call   80105104 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003ba:	bf d4 03 00 00       	mov    $0x3d4,%edi
801003bf:	b0 0e                	mov    $0xe,%al
801003c1:	89 fa                	mov    %edi,%edx
801003c3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003c4:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801003c9:	89 ca                	mov    %ecx,%edx
801003cb:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003cc:	0f b6 d8             	movzbl %al,%ebx
801003cf:	c1 e3 08             	shl    $0x8,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003d2:	b0 0f                	mov    $0xf,%al
801003d4:	89 fa                	mov    %edi,%edx
801003d6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003d7:	89 ca                	mov    %ecx,%edx
801003d9:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801003da:	0f b6 c0             	movzbl %al,%eax
801003dd:	09 c3                	or     %eax,%ebx
  if(c == '\n')
801003df:	83 fe 0a             	cmp    $0xa,%esi
801003e2:	0f 84 f8 00 00 00    	je     801004e0 <consputc+0x154>
  else if(c == BACKSPACE){
801003e8:	81 fe 00 01 00 00    	cmp    $0x100,%esi
801003ee:	0f 84 de 00 00 00    	je     801004d2 <consputc+0x146>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801003f4:	81 e6 ff 00 00 00    	and    $0xff,%esi
801003fa:	81 ce 00 07 00 00    	or     $0x700,%esi
80100400:	66 89 b4 1b 00 80 0b 	mov    %si,-0x7ff48000(%ebx,%ebx,1)
80100407:	80 
80100408:	43                   	inc    %ebx
  if(pos < 0 || pos > 25*80)
80100409:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010040f:	0f 87 b1 00 00 00    	ja     801004c6 <consputc+0x13a>
  if((pos/80) >= 24){  // Scroll up.
80100415:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
8010041b:	7f 5f                	jg     8010047c <consputc+0xf0>
8010041d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100424:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100429:	b0 0e                	mov    $0xe,%al
8010042b:	89 fa                	mov    %edi,%edx
8010042d:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
8010042e:	89 d8                	mov    %ebx,%eax
80100430:	c1 f8 08             	sar    $0x8,%eax
80100433:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100438:	89 ca                	mov    %ecx,%edx
8010043a:	ee                   	out    %al,(%dx)
8010043b:	b0 0f                	mov    $0xf,%al
8010043d:	89 fa                	mov    %edi,%edx
8010043f:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos);
80100440:	0f b6 c3             	movzbl %bl,%eax
80100443:	89 ca                	mov    %ecx,%edx
80100445:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
80100446:	66 c7 06 20 07       	movw   $0x720,(%esi)
}
8010044b:	83 c4 1c             	add    $0x1c,%esp
8010044e:	5b                   	pop    %ebx
8010044f:	5e                   	pop    %esi
80100450:	5f                   	pop    %edi
80100451:	5d                   	pop    %ebp
80100452:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100453:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010045a:	e8 a5 4c 00 00       	call   80105104 <uartputc>
8010045f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100466:	e8 99 4c 00 00       	call   80105104 <uartputc>
8010046b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100472:	e8 8d 4c 00 00       	call   80105104 <uartputc>
80100477:	e9 3e ff ff ff       	jmp    801003ba <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010047c:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
80100483:	00 
80100484:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
8010048b:	80 
8010048c:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
80100493:	e8 80 39 00 00       	call   80103e18 <memmove>
    pos -= 80;
80100498:	8d 7b b0             	lea    -0x50(%ebx),%edi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010049b:	8d b4 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%esi
801004a2:	b8 d0 07 00 00       	mov    $0x7d0,%eax
801004a7:	29 d8                	sub    %ebx,%eax
801004a9:	d1 e0                	shl    %eax
801004ab:	89 44 24 08          	mov    %eax,0x8(%esp)
801004af:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801004b6:	00 
801004b7:	89 34 24             	mov    %esi,(%esp)
801004ba:	e8 c5 38 00 00       	call   80103d84 <memset>
    pos -= 80;
801004bf:	89 fb                	mov    %edi,%ebx
801004c1:	e9 5e ff ff ff       	jmp    80100424 <consputc+0x98>
    panic("pos under/overflow");
801004c6:	c7 04 24 65 6c 10 80 	movl   $0x80106c65,(%esp)
801004cd:	e8 3e fe ff ff       	call   80100310 <panic>
    if(pos > 0) --pos;
801004d2:	85 db                	test   %ebx,%ebx
801004d4:	0f 8e 2f ff ff ff    	jle    80100409 <consputc+0x7d>
801004da:	4b                   	dec    %ebx
801004db:	e9 29 ff ff ff       	jmp    80100409 <consputc+0x7d>
    pos += 80 - pos%80;
801004e0:	b9 50 00 00 00       	mov    $0x50,%ecx
801004e5:	89 d8                	mov    %ebx,%eax
801004e7:	99                   	cltd   
801004e8:	f7 f9                	idiv   %ecx
801004ea:	29 d1                	sub    %edx,%ecx
801004ec:	01 cb                	add    %ecx,%ebx
801004ee:	e9 16 ff ff ff       	jmp    80100409 <consputc+0x7d>
801004f3:	90                   	nop

801004f4 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801004f4:	55                   	push   %ebp
801004f5:	89 e5                	mov    %esp,%ebp
801004f7:	57                   	push   %edi
801004f8:	56                   	push   %esi
801004f9:	53                   	push   %ebx
801004fa:	83 ec 1c             	sub    $0x1c,%esp
801004fd:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
80100500:	8b 45 08             	mov    0x8(%ebp),%eax
80100503:	89 04 24             	mov    %eax,(%esp)
80100506:	e8 15 11 00 00       	call   80101620 <iunlock>
  acquire(&cons.lock);
8010050b:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100512:	e8 69 37 00 00       	call   80103c80 <acquire>
  for(i = 0; i < n; i++)
80100517:	85 f6                	test   %esi,%esi
80100519:	7e 16                	jle    80100531 <consolewrite+0x3d>
8010051b:	8b 7d 0c             	mov    0xc(%ebp),%edi
consolewrite(struct inode *ip, char *buf, int n)
8010051e:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
80100521:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100524:	0f b6 07             	movzbl (%edi),%eax
80100527:	e8 60 fe ff ff       	call   8010038c <consputc>
8010052c:	47                   	inc    %edi
  for(i = 0; i < n; i++)
8010052d:	39 df                	cmp    %ebx,%edi
8010052f:	75 f3                	jne    80100524 <consolewrite+0x30>
  release(&cons.lock);
80100531:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100538:	e8 ff 37 00 00       	call   80103d3c <release>
  ilock(ip);
8010053d:	8b 45 08             	mov    0x8(%ebp),%eax
80100540:	89 04 24             	mov    %eax,(%esp)
80100543:	e8 08 10 00 00       	call   80101550 <ilock>

  return n;
}
80100548:	89 f0                	mov    %esi,%eax
8010054a:	83 c4 1c             	add    $0x1c,%esp
8010054d:	5b                   	pop    %ebx
8010054e:	5e                   	pop    %esi
8010054f:	5f                   	pop    %edi
80100550:	5d                   	pop    %ebp
80100551:	c3                   	ret    
80100552:	66 90                	xchg   %ax,%ax

80100554 <printint>:
{
80100554:	55                   	push   %ebp
80100555:	89 e5                	mov    %esp,%ebp
80100557:	57                   	push   %edi
80100558:	56                   	push   %esi
80100559:	53                   	push   %ebx
8010055a:	83 ec 1c             	sub    $0x1c,%esp
8010055d:	89 d6                	mov    %edx,%esi
  if(sign && (sign = xx < 0))
8010055f:	85 c9                	test   %ecx,%ecx
80100561:	74 4d                	je     801005b0 <printint+0x5c>
80100563:	85 c0                	test   %eax,%eax
80100565:	79 49                	jns    801005b0 <printint+0x5c>
    x = -xx;
80100567:	f7 d8                	neg    %eax
80100569:	bf 01 00 00 00       	mov    $0x1,%edi
  i = 0;
8010056e:	31 c9                	xor    %ecx,%ecx
80100570:	eb 04                	jmp    80100576 <printint+0x22>
80100572:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100574:	89 d9                	mov    %ebx,%ecx
80100576:	31 d2                	xor    %edx,%edx
80100578:	f7 f6                	div    %esi
8010057a:	8a 92 90 6c 10 80    	mov    -0x7fef9370(%edx),%dl
80100580:	88 54 0d d8          	mov    %dl,-0x28(%ebp,%ecx,1)
80100584:	8d 59 01             	lea    0x1(%ecx),%ebx
  }while((x /= base) != 0);
80100587:	85 c0                	test   %eax,%eax
80100589:	75 e9                	jne    80100574 <printint+0x20>
  if(sign)
8010058b:	85 ff                	test   %edi,%edi
8010058d:	74 08                	je     80100597 <printint+0x43>
    buf[i++] = '-';
8010058f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
80100594:	8d 59 02             	lea    0x2(%ecx),%ebx
  while(--i >= 0)
80100597:	4b                   	dec    %ebx
    consputc(buf[i]);
80100598:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
8010059d:	e8 ea fd ff ff       	call   8010038c <consputc>
  while(--i >= 0)
801005a2:	4b                   	dec    %ebx
801005a3:	83 fb ff             	cmp    $0xffffffff,%ebx
801005a6:	75 f0                	jne    80100598 <printint+0x44>
}
801005a8:	83 c4 1c             	add    $0x1c,%esp
801005ab:	5b                   	pop    %ebx
801005ac:	5e                   	pop    %esi
801005ad:	5f                   	pop    %edi
801005ae:	5d                   	pop    %ebp
801005af:	c3                   	ret    
    x = xx;
801005b0:	31 ff                	xor    %edi,%edi
801005b2:	eb ba                	jmp    8010056e <printint+0x1a>

801005b4 <cprintf>:
{
801005b4:	55                   	push   %ebp
801005b5:	89 e5                	mov    %esp,%ebp
801005b7:	57                   	push   %edi
801005b8:	56                   	push   %esi
801005b9:	53                   	push   %ebx
801005ba:	83 ec 2c             	sub    $0x2c,%esp
  locking = cons.locking;
801005bd:	a1 54 a5 10 80       	mov    0x8010a554,%eax
801005c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801005c5:	85 c0                	test   %eax,%eax
801005c7:	0f 85 0b 01 00 00    	jne    801006d8 <cprintf+0x124>
  if (fmt == 0)
801005cd:	8b 75 08             	mov    0x8(%ebp),%esi
801005d0:	85 f6                	test   %esi,%esi
801005d2:	0f 84 1b 01 00 00    	je     801006f3 <cprintf+0x13f>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801005d8:	0f b6 06             	movzbl (%esi),%eax
801005db:	85 c0                	test   %eax,%eax
801005dd:	74 7d                	je     8010065c <cprintf+0xa8>
  argp = (uint*)(void*)(&fmt + 1);
801005df:	8d 55 0c             	lea    0xc(%ebp),%edx
801005e2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801005e5:	31 db                	xor    %ebx,%ebx
801005e7:	eb 31                	jmp    8010061a <cprintf+0x66>
801005e9:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801005ec:	83 fa 25             	cmp    $0x25,%edx
801005ef:	0f 84 a3 00 00 00    	je     80100698 <cprintf+0xe4>
801005f5:	83 fa 64             	cmp    $0x64,%edx
801005f8:	74 7e                	je     80100678 <cprintf+0xc4>
      consputc('%');
801005fa:	b8 25 00 00 00       	mov    $0x25,%eax
801005ff:	89 55 dc             	mov    %edx,-0x24(%ebp)
80100602:	e8 85 fd ff ff       	call   8010038c <consputc>
      consputc(c);
80100607:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010060a:	89 d0                	mov    %edx,%eax
8010060c:	e8 7b fd ff ff       	call   8010038c <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100611:	43                   	inc    %ebx
80100612:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100616:	85 c0                	test   %eax,%eax
80100618:	74 42                	je     8010065c <cprintf+0xa8>
    if(c != '%'){
8010061a:	83 f8 25             	cmp    $0x25,%eax
8010061d:	75 ed                	jne    8010060c <cprintf+0x58>
    c = fmt[++i] & 0xff;
8010061f:	43                   	inc    %ebx
80100620:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
80100624:	85 d2                	test   %edx,%edx
80100626:	74 34                	je     8010065c <cprintf+0xa8>
    switch(c){
80100628:	83 fa 70             	cmp    $0x70,%edx
8010062b:	74 0c                	je     80100639 <cprintf+0x85>
8010062d:	7e bd                	jle    801005ec <cprintf+0x38>
8010062f:	83 fa 73             	cmp    $0x73,%edx
80100632:	74 74                	je     801006a8 <cprintf+0xf4>
80100634:	83 fa 78             	cmp    $0x78,%edx
80100637:	75 c1                	jne    801005fa <cprintf+0x46>
      printint(*argp++, 16, 0);
80100639:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010063c:	8b 02                	mov    (%edx),%eax
8010063e:	83 c2 04             	add    $0x4,%edx
80100641:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100644:	31 c9                	xor    %ecx,%ecx
80100646:	ba 10 00 00 00       	mov    $0x10,%edx
8010064b:	e8 04 ff ff ff       	call   80100554 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100650:	43                   	inc    %ebx
80100651:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100655:	85 c0                	test   %eax,%eax
80100657:	75 c1                	jne    8010061a <cprintf+0x66>
80100659:	8d 76 00             	lea    0x0(%esi),%esi
  if(locking)
8010065c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010065f:	85 c9                	test   %ecx,%ecx
80100661:	74 0c                	je     8010066f <cprintf+0xbb>
    release(&cons.lock);
80100663:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010066a:	e8 cd 36 00 00       	call   80103d3c <release>
}
8010066f:	83 c4 2c             	add    $0x2c,%esp
80100672:	5b                   	pop    %ebx
80100673:	5e                   	pop    %esi
80100674:	5f                   	pop    %edi
80100675:	5d                   	pop    %ebp
80100676:	c3                   	ret    
80100677:	90                   	nop
      printint(*argp++, 10, 1);
80100678:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010067b:	8b 02                	mov    (%edx),%eax
8010067d:	83 c2 04             	add    $0x4,%edx
80100680:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100683:	b9 01 00 00 00       	mov    $0x1,%ecx
80100688:	ba 0a 00 00 00       	mov    $0xa,%edx
8010068d:	e8 c2 fe ff ff       	call   80100554 <printint>
      break;
80100692:	e9 7a ff ff ff       	jmp    80100611 <cprintf+0x5d>
80100697:	90                   	nop
      consputc('%');
80100698:	b8 25 00 00 00       	mov    $0x25,%eax
8010069d:	e8 ea fc ff ff       	call   8010038c <consputc>
      break;
801006a2:	e9 6a ff ff ff       	jmp    80100611 <cprintf+0x5d>
801006a7:	90                   	nop
      if((s = (char*)*argp++) == 0)
801006a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006ab:	8b 38                	mov    (%eax),%edi
801006ad:	83 c0 04             	add    $0x4,%eax
801006b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b3:	85 ff                	test   %edi,%edi
801006b5:	74 35                	je     801006ec <cprintf+0x138>
      for(; *s; s++)
801006b7:	0f be 07             	movsbl (%edi),%eax
801006ba:	84 c0                	test   %al,%al
801006bc:	0f 84 4f ff ff ff    	je     80100611 <cprintf+0x5d>
801006c2:	66 90                	xchg   %ax,%ax
        consputc(*s);
801006c4:	e8 c3 fc ff ff       	call   8010038c <consputc>
      for(; *s; s++)
801006c9:	47                   	inc    %edi
801006ca:	0f be 07             	movsbl (%edi),%eax
801006cd:	84 c0                	test   %al,%al
801006cf:	75 f3                	jne    801006c4 <cprintf+0x110>
801006d1:	e9 3b ff ff ff       	jmp    80100611 <cprintf+0x5d>
801006d6:	66 90                	xchg   %ax,%ax
    acquire(&cons.lock);
801006d8:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006df:	e8 9c 35 00 00       	call   80103c80 <acquire>
801006e4:	e9 e4 fe ff ff       	jmp    801005cd <cprintf+0x19>
801006e9:	8d 76 00             	lea    0x0(%esi),%esi
        s = "(null)";
801006ec:	bf 78 6c 10 80       	mov    $0x80106c78,%edi
801006f1:	eb c4                	jmp    801006b7 <cprintf+0x103>
    panic("null fmt");
801006f3:	c7 04 24 7f 6c 10 80 	movl   $0x80106c7f,(%esp)
801006fa:	e8 11 fc ff ff       	call   80100310 <panic>
801006ff:	90                   	nop

80100700 <consoleintr>:
{
80100700:	55                   	push   %ebp
80100701:	89 e5                	mov    %esp,%ebp
80100703:	57                   	push   %edi
80100704:	56                   	push   %esi
80100705:	53                   	push   %ebx
80100706:	83 ec 1c             	sub    $0x1c,%esp
80100709:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010070c:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100713:	e8 68 35 00 00       	call   80103c80 <acquire>
  int c, doprocdump = 0;
80100718:	31 f6                	xor    %esi,%esi
8010071a:	66 90                	xchg   %ax,%ax
  while((c = getc()) >= 0){
8010071c:	ff d3                	call   *%ebx
8010071e:	89 c7                	mov    %eax,%edi
80100720:	85 c0                	test   %eax,%eax
80100722:	0f 88 90 00 00 00    	js     801007b8 <consoleintr+0xb8>
    switch(c){
80100728:	83 ff 10             	cmp    $0x10,%edi
8010072b:	0f 84 d7 00 00 00    	je     80100808 <consoleintr+0x108>
80100731:	0f 8f 9d 00 00 00    	jg     801007d4 <consoleintr+0xd4>
80100737:	83 ff 08             	cmp    $0x8,%edi
8010073a:	0f 84 a2 00 00 00    	je     801007e2 <consoleintr+0xe2>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100740:	85 ff                	test   %edi,%edi
80100742:	74 d8                	je     8010071c <consoleintr+0x1c>
80100744:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100749:	89 c2                	mov    %eax,%edx
8010074b:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100751:	83 fa 7f             	cmp    $0x7f,%edx
80100754:	77 c6                	ja     8010071c <consoleintr+0x1c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100756:	89 c2                	mov    %eax,%edx
80100758:	83 e2 7f             	and    $0x7f,%edx
        c = (c == '\r') ? '\n' : c;
8010075b:	83 ff 0d             	cmp    $0xd,%edi
8010075e:	0f 84 04 01 00 00    	je     80100868 <consoleintr+0x168>
        input.buf[input.e++ % INPUT_BUF] = c;
80100764:	89 f9                	mov    %edi,%ecx
80100766:	88 8a 20 ff 10 80    	mov    %cl,-0x7fef00e0(%edx)
8010076c:	40                   	inc    %eax
8010076d:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(c);
80100772:	89 f8                	mov    %edi,%eax
80100774:	e8 13 fc ff ff       	call   8010038c <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100779:	83 ff 0a             	cmp    $0xa,%edi
8010077c:	0f 84 fd 00 00 00    	je     8010087f <consoleintr+0x17f>
80100782:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100787:	83 ff 04             	cmp    $0x4,%edi
8010078a:	74 0d                	je     80100799 <consoleintr+0x99>
8010078c:	8b 15 a0 ff 10 80    	mov    0x8010ffa0,%edx
80100792:	83 ea 80             	sub    $0xffffff80,%edx
80100795:	39 d0                	cmp    %edx,%eax
80100797:	75 83                	jne    8010071c <consoleintr+0x1c>
          input.w = input.e;
80100799:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
8010079e:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801007a5:	e8 92 31 00 00       	call   8010393c <wakeup>
  while((c = getc()) >= 0){
801007aa:	ff d3                	call   *%ebx
801007ac:	89 c7                	mov    %eax,%edi
801007ae:	85 c0                	test   %eax,%eax
801007b0:	0f 89 72 ff ff ff    	jns    80100728 <consoleintr+0x28>
801007b6:	66 90                	xchg   %ax,%ax
  release(&cons.lock);
801007b8:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007bf:	e8 78 35 00 00       	call   80103d3c <release>
  if(doprocdump) {
801007c4:	85 f6                	test   %esi,%esi
801007c6:	0f 85 90 00 00 00    	jne    8010085c <consoleintr+0x15c>
}
801007cc:	83 c4 1c             	add    $0x1c,%esp
801007cf:	5b                   	pop    %ebx
801007d0:	5e                   	pop    %esi
801007d1:	5f                   	pop    %edi
801007d2:	5d                   	pop    %ebp
801007d3:	c3                   	ret    
    switch(c){
801007d4:	83 ff 15             	cmp    $0x15,%edi
801007d7:	74 3b                	je     80100814 <consoleintr+0x114>
801007d9:	83 ff 7f             	cmp    $0x7f,%edi
801007dc:	0f 85 5e ff ff ff    	jne    80100740 <consoleintr+0x40>
      if(input.e != input.w){
801007e2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007e7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007ed:	0f 84 29 ff ff ff    	je     8010071c <consoleintr+0x1c>
        input.e--;
801007f3:	48                   	dec    %eax
801007f4:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801007f9:	b8 00 01 00 00       	mov    $0x100,%eax
801007fe:	e8 89 fb ff ff       	call   8010038c <consputc>
80100803:	e9 14 ff ff ff       	jmp    8010071c <consoleintr+0x1c>
      doprocdump = 1;
80100808:	be 01 00 00 00       	mov    $0x1,%esi
8010080d:	e9 0a ff ff ff       	jmp    8010071c <consoleintr+0x1c>
80100812:	66 90                	xchg   %ax,%ax
      while(input.e != input.w &&
80100814:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100819:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010081f:	75 27                	jne    80100848 <consoleintr+0x148>
80100821:	e9 f6 fe ff ff       	jmp    8010071c <consoleintr+0x1c>
80100826:	66 90                	xchg   %ax,%ax
        input.e--;
80100828:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
8010082d:	b8 00 01 00 00       	mov    $0x100,%eax
80100832:	e8 55 fb ff ff       	call   8010038c <consputc>
      while(input.e != input.w &&
80100837:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010083c:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100842:	0f 84 d4 fe ff ff    	je     8010071c <consoleintr+0x1c>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100848:	48                   	dec    %eax
80100849:	89 c2                	mov    %eax,%edx
8010084b:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
8010084e:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100855:	75 d1                	jne    80100828 <consoleintr+0x128>
80100857:	e9 c0 fe ff ff       	jmp    8010071c <consoleintr+0x1c>
}
8010085c:	83 c4 1c             	add    $0x1c,%esp
8010085f:	5b                   	pop    %ebx
80100860:	5e                   	pop    %esi
80100861:	5f                   	pop    %edi
80100862:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100863:	e9 ac 31 00 00       	jmp    80103a14 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	c6 82 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%edx)
8010086f:	40                   	inc    %eax
80100870:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(c);
80100875:	b8 0a 00 00 00       	mov    $0xa,%eax
8010087a:	e8 0d fb ff ff       	call   8010038c <consputc>
8010087f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100884:	e9 10 ff ff ff       	jmp    80100799 <consoleintr+0x99>
80100889:	8d 76 00             	lea    0x0(%esi),%esi

8010088c <consoleinit>:

void
consoleinit(void)
{
8010088c:	55                   	push   %ebp
8010088d:	89 e5                	mov    %esp,%ebp
8010088f:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100892:	c7 44 24 04 88 6c 10 	movl   $0x80106c88,0x4(%esp)
80100899:	80 
8010089a:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801008a1:	e8 12 33 00 00       	call   80103bb8 <initlock>

  devsw[CONSOLE].write = consolewrite;
801008a6:	c7 05 6c 09 11 80 f4 	movl   $0x801004f4,0x8011096c
801008ad:	04 10 80 
  devsw[CONSOLE].read = consoleread;
801008b0:	c7 05 68 09 11 80 28 	movl   $0x80100228,0x80110968
801008b7:	02 10 80 
  cons.locking = 1;
801008ba:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801008c1:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801008c4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801008cb:	00 
801008cc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801008d3:	e8 a4 17 00 00       	call   8010207c <ioapicenable>
}
801008d8:	c9                   	leave  
801008d9:	c3                   	ret    
801008da:	66 90                	xchg   %ax,%ax

801008dc <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801008dc:	55                   	push   %ebp
801008dd:	89 e5                	mov    %esp,%ebp
801008df:	57                   	push   %edi
801008e0:	56                   	push   %esi
801008e1:	53                   	push   %ebx
801008e2:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801008e8:	e8 a3 29 00 00       	call   80103290 <myproc>
801008ed:	89 c7                	mov    %eax,%edi

  begin_op();
801008ef:	e8 a4 1e 00 00       	call   80102798 <begin_op>

  if((ip = namei(path)) == 0){
801008f4:	8b 55 08             	mov    0x8(%ebp),%edx
801008f7:	89 14 24             	mov    %edx,(%esp)
801008fa:	e8 29 14 00 00       	call   80101d28 <namei>
801008ff:	89 c3                	mov    %eax,%ebx
80100901:	85 c0                	test   %eax,%eax
80100903:	0f 84 cb 01 00 00    	je     80100ad4 <exec+0x1f8>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100909:	89 04 24             	mov    %eax,(%esp)
8010090c:	e8 3f 0c 00 00       	call   80101550 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100911:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100918:	00 
80100919:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100920:	00 
80100921:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100927:	89 44 24 04          	mov    %eax,0x4(%esp)
8010092b:	89 1c 24             	mov    %ebx,(%esp)
8010092e:	e8 b9 0e 00 00       	call   801017ec <readi>
80100933:	83 f8 34             	cmp    $0x34,%eax
80100936:	74 20                	je     80100958 <exec+0x7c>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100938:	89 1c 24             	mov    %ebx,(%esp)
8010093b:	e8 60 0e 00 00       	call   801017a0 <iunlockput>
    end_op();
80100940:	e8 af 1e 00 00       	call   801027f4 <end_op>
  }
  return -1;
80100945:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010094a:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100950:	5b                   	pop    %ebx
80100951:	5e                   	pop    %esi
80100952:	5f                   	pop    %edi
80100953:	5d                   	pop    %ebp
80100954:	c3                   	ret    
80100955:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100958:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
8010095f:	45 4c 46 
80100962:	75 d4                	jne    80100938 <exec+0x5c>
  if((pgdir = setupkvm()) == 0)
80100964:	e8 6b 59 00 00       	call   801062d4 <setupkvm>
80100969:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
8010096f:	85 c0                	test   %eax,%eax
80100971:	74 c5                	je     80100938 <exec+0x5c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100973:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100979:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100980:	00 
80100981:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
80100988:	00 00 00 
8010098b:	0f 84 e8 00 00 00    	je     80100a79 <exec+0x19d>
80100991:	31 d2                	xor    %edx,%edx
80100993:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100999:	89 d7                	mov    %edx,%edi
8010099b:	eb 16                	jmp    801009b3 <exec+0xd7>
8010099d:	8d 76 00             	lea    0x0(%esi),%esi
801009a0:	47                   	inc    %edi
exec(char *path, char **argv)
801009a1:	83 c6 20             	add    $0x20,%esi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009a4:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
801009ab:	39 f8                	cmp    %edi,%eax
801009ad:	0f 8e c0 00 00 00    	jle    80100a73 <exec+0x197>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801009b3:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
801009ba:	00 
801009bb:	89 74 24 08          	mov    %esi,0x8(%esp)
801009bf:	8d 8d 04 ff ff ff    	lea    -0xfc(%ebp),%ecx
801009c5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
801009c9:	89 1c 24             	mov    %ebx,(%esp)
801009cc:	e8 1b 0e 00 00       	call   801017ec <readi>
801009d1:	83 f8 20             	cmp    $0x20,%eax
801009d4:	0f 85 86 00 00 00    	jne    80100a60 <exec+0x184>
    if(ph.type != ELF_PROG_LOAD)
801009da:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801009e1:	75 bd                	jne    801009a0 <exec+0xc4>
    if(ph.memsz < ph.filesz)
801009e3:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801009e9:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801009ef:	72 6f                	jb     80100a60 <exec+0x184>
    if(ph.vaddr + ph.memsz < ph.vaddr)
801009f1:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801009f7:	72 67                	jb     80100a60 <exec+0x184>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801009f9:	89 44 24 08          	mov    %eax,0x8(%esp)
801009fd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100a03:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a07:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100a0d:	89 04 24             	mov    %eax,(%esp)
80100a10:	e8 1b 57 00 00       	call   80106130 <allocuvm>
80100a15:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100a1b:	85 c0                	test   %eax,%eax
80100a1d:	74 41                	je     80100a60 <exec+0x184>
    if(ph.vaddr % PGSIZE != 0)
80100a1f:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a25:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a2a:	75 34                	jne    80100a60 <exec+0x184>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a2c:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100a32:	89 54 24 10          	mov    %edx,0x10(%esp)
80100a36:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100a3c:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100a40:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100a44:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a48:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100a4e:	89 04 24             	mov    %eax,(%esp)
80100a51:	e8 76 55 00 00       	call   80105fcc <loaduvm>
80100a56:	85 c0                	test   %eax,%eax
80100a58:	0f 89 42 ff ff ff    	jns    801009a0 <exec+0xc4>
80100a5e:	66 90                	xchg   %ax,%ax
    freevm(pgdir);
80100a60:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100a66:	89 04 24             	mov    %eax,(%esp)
80100a69:	e8 f2 57 00 00       	call   80106260 <freevm>
80100a6e:	e9 c5 fe ff ff       	jmp    80100938 <exec+0x5c>
80100a73:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
  iunlockput(ip);
80100a79:	89 1c 24             	mov    %ebx,(%esp)
80100a7c:	e8 1f 0d 00 00       	call   801017a0 <iunlockput>
  end_op();
80100a81:	e8 6e 1d 00 00       	call   801027f4 <end_op>
  sz = PGROUNDUP(sz);
80100a86:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100a8c:	05 ff 0f 00 00       	add    $0xfff,%eax
80100a91:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100a96:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100a9c:	89 54 24 08          	mov    %edx,0x8(%esp)
80100aa0:	89 44 24 04          	mov    %eax,0x4(%esp)
80100aa4:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100aaa:	89 04 24             	mov    %eax,(%esp)
80100aad:	e8 7e 56 00 00       	call   80106130 <allocuvm>
80100ab2:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100ab8:	85 c0                	test   %eax,%eax
80100aba:	75 33                	jne    80100aef <exec+0x213>
    freevm(pgdir);
80100abc:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ac2:	89 04 24             	mov    %eax,(%esp)
80100ac5:	e8 96 57 00 00       	call   80106260 <freevm>
  return -1;
80100aca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100acf:	e9 76 fe ff ff       	jmp    8010094a <exec+0x6e>
    end_op();
80100ad4:	e8 1b 1d 00 00       	call   801027f4 <end_op>
    cprintf("exec: fail\n");
80100ad9:	c7 04 24 a1 6c 10 80 	movl   $0x80106ca1,(%esp)
80100ae0:	e8 cf fa ff ff       	call   801005b4 <cprintf>
    return -1;
80100ae5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100aea:	e9 5b fe ff ff       	jmp    8010094a <exec+0x6e>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100aef:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100af5:	2d 00 20 00 00       	sub    $0x2000,%eax
80100afa:	89 44 24 04          	mov    %eax,0x4(%esp)
80100afe:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b04:	89 04 24             	mov    %eax,(%esp)
80100b07:	e8 5c 58 00 00       	call   80106368 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100b0c:	8b 55 0c             	mov    0xc(%ebp),%edx
80100b0f:	8b 02                	mov    (%edx),%eax
80100b11:	85 c0                	test   %eax,%eax
80100b13:	0f 84 4e 01 00 00    	je     80100c67 <exec+0x38b>
exec(char *path, char **argv)
80100b19:	89 d1                	mov    %edx,%ecx
80100b1b:	83 c1 04             	add    $0x4,%ecx
80100b1e:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
  for(argc = 0; argv[argc]; argc++) {
80100b24:	31 f6                	xor    %esi,%esi
80100b26:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100b2c:	89 cf                	mov    %ecx,%edi
80100b2e:	eb 08                	jmp    80100b38 <exec+0x25c>
80100b30:	83 c7 04             	add    $0x4,%edi
    if(argc >= MAXARG)
80100b33:	83 fe 20             	cmp    $0x20,%esi
80100b36:	74 84                	je     80100abc <exec+0x1e0>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100b38:	89 04 24             	mov    %eax,(%esp)
80100b3b:	e8 0c 34 00 00       	call   80103f4c <strlen>
80100b40:	f7 d0                	not    %eax
80100b42:	01 c3                	add    %eax,%ebx
80100b44:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100b4a:	8b 01                	mov    (%ecx),%eax
80100b4c:	89 04 24             	mov    %eax,(%esp)
80100b4f:	e8 f8 33 00 00       	call   80103f4c <strlen>
80100b54:	40                   	inc    %eax
80100b55:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100b59:	8b 55 0c             	mov    0xc(%ebp),%edx
80100b5c:	8b 02                	mov    (%edx),%eax
80100b5e:	89 44 24 08          	mov    %eax,0x8(%esp)
80100b62:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100b66:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b6c:	89 04 24             	mov    %eax,(%esp)
80100b6f:	e8 28 59 00 00       	call   8010649c <copyout>
80100b74:	85 c0                	test   %eax,%eax
80100b76:	0f 88 40 ff ff ff    	js     80100abc <exec+0x1e0>
    ustack[3+argc] = sp;
80100b7c:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100b82:	89 9c b5 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%esi,4)
  for(argc = 0; argv[argc]; argc++) {
80100b89:	46                   	inc    %esi
80100b8a:	89 7d 0c             	mov    %edi,0xc(%ebp)
80100b8d:	8b 07                	mov    (%edi),%eax
80100b8f:	85 c0                	test   %eax,%eax
80100b91:	75 9d                	jne    80100b30 <exec+0x254>
80100b93:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
  ustack[3+argc] = 0;
80100b99:	c7 84 b5 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%esi,4)
80100ba0:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ba4:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100bab:	ff ff ff 
  ustack[1] = argc;
80100bae:	89 b5 5c ff ff ff    	mov    %esi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100bb4:	8d 04 b5 04 00 00 00 	lea    0x4(,%esi,4),%eax
80100bbb:	89 d9                	mov    %ebx,%ecx
80100bbd:	29 c1                	sub    %eax,%ecx
80100bbf:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100bc5:	8d 04 b5 10 00 00 00 	lea    0x10(,%esi,4),%eax
80100bcc:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100bce:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100bd2:	89 54 24 08          	mov    %edx,0x8(%esp)
80100bd6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100bda:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100be0:	89 04 24             	mov    %eax,(%esp)
80100be3:	e8 b4 58 00 00       	call   8010649c <copyout>
80100be8:	85 c0                	test   %eax,%eax
80100bea:	0f 88 cc fe ff ff    	js     80100abc <exec+0x1e0>
  for(last=s=path; *s; s++)
80100bf0:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100bf3:	8a 11                	mov    (%ecx),%dl
80100bf5:	84 d2                	test   %dl,%dl
80100bf7:	74 17                	je     80100c10 <exec+0x334>
exec(char *path, char **argv)
80100bf9:	89 c8                	mov    %ecx,%eax
80100bfb:	40                   	inc    %eax
80100bfc:	eb 09                	jmp    80100c07 <exec+0x32b>
80100bfe:	66 90                	xchg   %ax,%ax
  for(last=s=path; *s; s++)
80100c00:	8a 10                	mov    (%eax),%dl
80100c02:	40                   	inc    %eax
80100c03:	84 d2                	test   %dl,%dl
80100c05:	74 0c                	je     80100c13 <exec+0x337>
    if(*s == '/')
80100c07:	80 fa 2f             	cmp    $0x2f,%dl
80100c0a:	75 f4                	jne    80100c00 <exec+0x324>
      last = s+1;
80100c0c:	89 c1                	mov    %eax,%ecx
80100c0e:	eb f0                	jmp    80100c00 <exec+0x324>
  for(last=s=path; *s; s++)
80100c10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100c13:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100c1a:	00 
80100c1b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80100c1f:	8d 47 6c             	lea    0x6c(%edi),%eax
80100c22:	89 04 24             	mov    %eax,(%esp)
80100c25:	e8 f2 32 00 00       	call   80103f1c <safestrcpy>
  oldpgdir = curproc->pgdir;
80100c2a:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->pgdir = pgdir;
80100c2d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c33:	89 47 04             	mov    %eax,0x4(%edi)
  curproc->sz = sz;
80100c36:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
80100c3c:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100c3e:	8b 47 18             	mov    0x18(%edi),%eax
80100c41:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100c47:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100c4a:	8b 47 18             	mov    0x18(%edi),%eax
80100c4d:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100c50:	89 3c 24             	mov    %edi,(%esp)
80100c53:	e8 f8 51 00 00       	call   80105e50 <switchuvm>
  freevm(oldpgdir);
80100c58:	89 34 24             	mov    %esi,(%esp)
80100c5b:	e8 00 56 00 00       	call   80106260 <freevm>
  return 0;
80100c60:	31 c0                	xor    %eax,%eax
80100c62:	e9 e3 fc ff ff       	jmp    8010094a <exec+0x6e>
  for(argc = 0; argv[argc]; argc++) {
80100c67:	8b 9d f4 fe ff ff    	mov    -0x10c(%ebp),%ebx
80100c6d:	31 f6                	xor    %esi,%esi
80100c6f:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c75:	e9 1f ff ff ff       	jmp    80100b99 <exec+0x2bd>
80100c7a:	66 90                	xchg   %ax,%ax

80100c7c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c7c:	55                   	push   %ebp
80100c7d:	89 e5                	mov    %esp,%ebp
80100c7f:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100c82:	c7 44 24 04 ad 6c 10 	movl   $0x80106cad,0x4(%esp)
80100c89:	80 
80100c8a:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100c91:	e8 22 2f 00 00       	call   80103bb8 <initlock>
}
80100c96:	c9                   	leave  
80100c97:	c3                   	ret    

80100c98 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c98:	55                   	push   %ebp
80100c99:	89 e5                	mov    %esp,%ebp
80100c9b:	53                   	push   %ebx
80100c9c:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c9f:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100ca6:	e8 d5 2f 00 00       	call   80103c80 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100cab:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
80100cb0:	eb 0d                	jmp    80100cbf <filealloc+0x27>
80100cb2:	66 90                	xchg   %ax,%ax
80100cb4:	83 c3 18             	add    $0x18,%ebx
80100cb7:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100cbd:	74 25                	je     80100ce4 <filealloc+0x4c>
    if(f->ref == 0){
80100cbf:	8b 43 04             	mov    0x4(%ebx),%eax
80100cc2:	85 c0                	test   %eax,%eax
80100cc4:	75 ee                	jne    80100cb4 <filealloc+0x1c>
      f->ref = 1;
80100cc6:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100ccd:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100cd4:	e8 63 30 00 00       	call   80103d3c <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100cd9:	89 d8                	mov    %ebx,%eax
80100cdb:	83 c4 14             	add    $0x14,%esp
80100cde:	5b                   	pop    %ebx
80100cdf:	5d                   	pop    %ebp
80100ce0:	c3                   	ret    
80100ce1:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100ce4:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100ceb:	e8 4c 30 00 00       	call   80103d3c <release>
  return 0;
80100cf0:	31 db                	xor    %ebx,%ebx
}
80100cf2:	89 d8                	mov    %ebx,%eax
80100cf4:	83 c4 14             	add    $0x14,%esp
80100cf7:	5b                   	pop    %ebx
80100cf8:	5d                   	pop    %ebp
80100cf9:	c3                   	ret    
80100cfa:	66 90                	xchg   %ax,%ax

80100cfc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100cfc:	55                   	push   %ebp
80100cfd:	89 e5                	mov    %esp,%ebp
80100cff:	53                   	push   %ebx
80100d00:	83 ec 14             	sub    $0x14,%esp
80100d03:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100d06:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d0d:	e8 6e 2f 00 00       	call   80103c80 <acquire>
  if(f->ref < 1)
80100d12:	8b 43 04             	mov    0x4(%ebx),%eax
80100d15:	85 c0                	test   %eax,%eax
80100d17:	7e 18                	jle    80100d31 <filedup+0x35>
    panic("filedup");
  f->ref++;
80100d19:	40                   	inc    %eax
80100d1a:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100d1d:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d24:	e8 13 30 00 00       	call   80103d3c <release>
  return f;
}
80100d29:	89 d8                	mov    %ebx,%eax
80100d2b:	83 c4 14             	add    $0x14,%esp
80100d2e:	5b                   	pop    %ebx
80100d2f:	5d                   	pop    %ebp
80100d30:	c3                   	ret    
    panic("filedup");
80100d31:	c7 04 24 b4 6c 10 80 	movl   $0x80106cb4,(%esp)
80100d38:	e8 d3 f5 ff ff       	call   80100310 <panic>
80100d3d:	8d 76 00             	lea    0x0(%esi),%esi

80100d40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100d40:	55                   	push   %ebp
80100d41:	89 e5                	mov    %esp,%ebp
80100d43:	57                   	push   %edi
80100d44:	56                   	push   %esi
80100d45:	53                   	push   %ebx
80100d46:	83 ec 2c             	sub    $0x2c,%esp
80100d49:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100d4c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d53:	e8 28 2f 00 00       	call   80103c80 <acquire>
  if(f->ref < 1)
80100d58:	8b 57 04             	mov    0x4(%edi),%edx
80100d5b:	85 d2                	test   %edx,%edx
80100d5d:	0f 8e 85 00 00 00    	jle    80100de8 <fileclose+0xa8>
    panic("fileclose");
  if(--f->ref > 0){
80100d63:	4a                   	dec    %edx
80100d64:	89 57 04             	mov    %edx,0x4(%edi)
80100d67:	85 d2                	test   %edx,%edx
80100d69:	74 15                	je     80100d80 <fileclose+0x40>
    release(&ftable.lock);
80100d6b:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100d72:	83 c4 2c             	add    $0x2c,%esp
80100d75:	5b                   	pop    %ebx
80100d76:	5e                   	pop    %esi
80100d77:	5f                   	pop    %edi
80100d78:	5d                   	pop    %ebp
    release(&ftable.lock);
80100d79:	e9 be 2f 00 00       	jmp    80103d3c <release>
80100d7e:	66 90                	xchg   %ax,%ax
  ff = *f;
80100d80:	8b 1f                	mov    (%edi),%ebx
80100d82:	8a 47 09             	mov    0x9(%edi),%al
80100d85:	88 45 e7             	mov    %al,-0x19(%ebp)
80100d88:	8b 77 0c             	mov    0xc(%edi),%esi
80100d8b:	8b 47 10             	mov    0x10(%edi),%eax
80100d8e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->type = FD_NONE;
80100d91:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  release(&ftable.lock);
80100d97:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d9e:	e8 99 2f 00 00       	call   80103d3c <release>
  if(ff.type == FD_PIPE)
80100da3:	83 fb 01             	cmp    $0x1,%ebx
80100da6:	74 10                	je     80100db8 <fileclose+0x78>
  else if(ff.type == FD_INODE){
80100da8:	83 fb 02             	cmp    $0x2,%ebx
80100dab:	74 1f                	je     80100dcc <fileclose+0x8c>
}
80100dad:	83 c4 2c             	add    $0x2c,%esp
80100db0:	5b                   	pop    %ebx
80100db1:	5e                   	pop    %esi
80100db2:	5f                   	pop    %edi
80100db3:	5d                   	pop    %ebp
80100db4:	c3                   	ret    
80100db5:	8d 76 00             	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100db8:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
80100dbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80100dc0:	89 34 24             	mov    %esi,(%esp)
80100dc3:	e8 8c 20 00 00       	call   80102e54 <pipeclose>
80100dc8:	eb e3                	jmp    80100dad <fileclose+0x6d>
80100dca:	66 90                	xchg   %ax,%ax
    begin_op();
80100dcc:	e8 c7 19 00 00       	call   80102798 <begin_op>
    iput(ff.ip);
80100dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100dd4:	89 04 24             	mov    %eax,(%esp)
80100dd7:	e8 84 08 00 00       	call   80101660 <iput>
}
80100ddc:	83 c4 2c             	add    $0x2c,%esp
80100ddf:	5b                   	pop    %ebx
80100de0:	5e                   	pop    %esi
80100de1:	5f                   	pop    %edi
80100de2:	5d                   	pop    %ebp
    end_op();
80100de3:	e9 0c 1a 00 00       	jmp    801027f4 <end_op>
    panic("fileclose");
80100de8:	c7 04 24 bc 6c 10 80 	movl   $0x80106cbc,(%esp)
80100def:	e8 1c f5 ff ff       	call   80100310 <panic>

80100df4 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100df4:	55                   	push   %ebp
80100df5:	89 e5                	mov    %esp,%ebp
80100df7:	53                   	push   %ebx
80100df8:	83 ec 14             	sub    $0x14,%esp
80100dfb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100dfe:	83 3b 02             	cmpl   $0x2,(%ebx)
80100e01:	75 31                	jne    80100e34 <filestat+0x40>
    ilock(f->ip);
80100e03:	8b 43 10             	mov    0x10(%ebx),%eax
80100e06:	89 04 24             	mov    %eax,(%esp)
80100e09:	e8 42 07 00 00       	call   80101550 <ilock>
    stati(f->ip, st);
80100e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e11:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e15:	8b 43 10             	mov    0x10(%ebx),%eax
80100e18:	89 04 24             	mov    %eax,(%esp)
80100e1b:	e8 a0 09 00 00       	call   801017c0 <stati>
    iunlock(f->ip);
80100e20:	8b 43 10             	mov    0x10(%ebx),%eax
80100e23:	89 04 24             	mov    %eax,(%esp)
80100e26:	e8 f5 07 00 00       	call   80101620 <iunlock>
    return 0;
80100e2b:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100e2d:	83 c4 14             	add    $0x14,%esp
80100e30:	5b                   	pop    %ebx
80100e31:	5d                   	pop    %ebp
80100e32:	c3                   	ret    
80100e33:	90                   	nop
  return -1;
80100e34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100e39:	83 c4 14             	add    $0x14,%esp
80100e3c:	5b                   	pop    %ebx
80100e3d:	5d                   	pop    %ebp
80100e3e:	c3                   	ret    
80100e3f:	90                   	nop

80100e40 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 2c             	sub    $0x2c,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100e4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100e4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100e52:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100e56:	74 68                	je     80100ec0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100e58:	8b 03                	mov    (%ebx),%eax
80100e5a:	83 f8 01             	cmp    $0x1,%eax
80100e5d:	74 4d                	je     80100eac <fileread+0x6c>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e5f:	83 f8 02             	cmp    $0x2,%eax
80100e62:	75 63                	jne    80100ec7 <fileread+0x87>
    ilock(f->ip);
80100e64:	8b 43 10             	mov    0x10(%ebx),%eax
80100e67:	89 04 24             	mov    %eax,(%esp)
80100e6a:	e8 e1 06 00 00       	call   80101550 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100e6f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100e73:	8b 43 14             	mov    0x14(%ebx),%eax
80100e76:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e7a:	89 74 24 04          	mov    %esi,0x4(%esp)
80100e7e:	8b 43 10             	mov    0x10(%ebx),%eax
80100e81:	89 04 24             	mov    %eax,(%esp)
80100e84:	e8 63 09 00 00       	call   801017ec <readi>
80100e89:	85 c0                	test   %eax,%eax
80100e8b:	7e 03                	jle    80100e90 <fileread+0x50>
      f->off += r;
80100e8d:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e90:	8b 53 10             	mov    0x10(%ebx),%edx
80100e93:	89 14 24             	mov    %edx,(%esp)
80100e96:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100e99:	e8 82 07 00 00       	call   80101620 <iunlock>
    return r;
80100e9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  panic("fileread");
}
80100ea1:	83 c4 2c             	add    $0x2c,%esp
80100ea4:	5b                   	pop    %ebx
80100ea5:	5e                   	pop    %esi
80100ea6:	5f                   	pop    %edi
80100ea7:	5d                   	pop    %ebp
80100ea8:	c3                   	ret    
80100ea9:	8d 76 00             	lea    0x0(%esi),%esi
    return piperead(f->pipe, addr, n);
80100eac:	8b 43 0c             	mov    0xc(%ebx),%eax
80100eaf:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100eb2:	83 c4 2c             	add    $0x2c,%esp
80100eb5:	5b                   	pop    %ebx
80100eb6:	5e                   	pop    %esi
80100eb7:	5f                   	pop    %edi
80100eb8:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100eb9:	e9 f6 20 00 00       	jmp    80102fb4 <piperead>
80100ebe:	66 90                	xchg   %ax,%ax
    return -1;
80100ec0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ec5:	eb da                	jmp    80100ea1 <fileread+0x61>
  panic("fileread");
80100ec7:	c7 04 24 c6 6c 10 80 	movl   $0x80106cc6,(%esp)
80100ece:	e8 3d f4 ff ff       	call   80100310 <panic>
80100ed3:	90                   	nop

80100ed4 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ed4:	55                   	push   %ebp
80100ed5:	89 e5                	mov    %esp,%ebp
80100ed7:	57                   	push   %edi
80100ed8:	56                   	push   %esi
80100ed9:	53                   	push   %ebx
80100eda:	83 ec 2c             	sub    $0x2c,%esp
80100edd:	8b 7d 08             	mov    0x8(%ebp),%edi
80100ee0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ee3:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ee6:	8b 45 10             	mov    0x10(%ebp),%eax
80100ee9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100eec:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
80100ef0:	0f 84 a9 00 00 00    	je     80100f9f <filewrite+0xcb>
    return -1;
  if(f->type == FD_PIPE)
80100ef6:	8b 07                	mov    (%edi),%eax
80100ef8:	83 f8 01             	cmp    $0x1,%eax
80100efb:	0f 84 c3 00 00 00    	je     80100fc4 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f01:	83 f8 02             	cmp    $0x2,%eax
80100f04:	0f 85 d8 00 00 00    	jne    80100fe2 <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80100f0a:	31 db                	xor    %ebx,%ebx
80100f0c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100f0f:	85 d2                	test   %edx,%edx
80100f11:	7f 2d                	jg     80100f40 <filewrite+0x6c>
80100f13:	e9 9c 00 00 00       	jmp    80100fb4 <filewrite+0xe0>
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80100f18:	01 47 14             	add    %eax,0x14(%edi)
      iunlock(f->ip);
80100f1b:	8b 4f 10             	mov    0x10(%edi),%ecx
80100f1e:	89 0c 24             	mov    %ecx,(%esp)
80100f21:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100f24:	e8 f7 06 00 00       	call   80101620 <iunlock>
      end_op();
80100f29:	e8 c6 18 00 00       	call   801027f4 <end_op>
80100f2e:	8b 45 dc             	mov    -0x24(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80100f31:	39 f0                	cmp    %esi,%eax
80100f33:	0f 85 9d 00 00 00    	jne    80100fd6 <filewrite+0x102>
        panic("short filewrite");
      i += r;
80100f39:	01 c3                	add    %eax,%ebx
    while(i < n){
80100f3b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100f3e:	7e 74                	jle    80100fb4 <filewrite+0xe0>
80100f40:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80100f43:	29 de                	sub    %ebx,%esi
80100f45:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80100f4b:	7e 05                	jle    80100f52 <filewrite+0x7e>
80100f4d:	be 00 06 00 00       	mov    $0x600,%esi
      begin_op();
80100f52:	e8 41 18 00 00       	call   80102798 <begin_op>
      ilock(f->ip);
80100f57:	8b 47 10             	mov    0x10(%edi),%eax
80100f5a:	89 04 24             	mov    %eax,(%esp)
80100f5d:	e8 ee 05 00 00       	call   80101550 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100f62:	89 74 24 0c          	mov    %esi,0xc(%esp)
80100f66:	8b 47 14             	mov    0x14(%edi),%eax
80100f69:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f6d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100f70:	01 d8                	add    %ebx,%eax
80100f72:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f76:	8b 47 10             	mov    0x10(%edi),%eax
80100f79:	89 04 24             	mov    %eax,(%esp)
80100f7c:	e8 6f 09 00 00       	call   801018f0 <writei>
80100f81:	85 c0                	test   %eax,%eax
80100f83:	7f 93                	jg     80100f18 <filewrite+0x44>
      iunlock(f->ip);
80100f85:	8b 4f 10             	mov    0x10(%edi),%ecx
80100f88:	89 0c 24             	mov    %ecx,(%esp)
80100f8b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100f8e:	e8 8d 06 00 00       	call   80101620 <iunlock>
      end_op();
80100f93:	e8 5c 18 00 00       	call   801027f4 <end_op>
      if(r < 0)
80100f98:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100f9b:	85 c0                	test   %eax,%eax
80100f9d:	74 92                	je     80100f31 <filewrite+0x5d>
    return -1;
80100f9f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
80100fa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fa9:	83 c4 2c             	add    $0x2c,%esp
80100fac:	5b                   	pop    %ebx
80100fad:	5e                   	pop    %esi
80100fae:	5f                   	pop    %edi
80100faf:	5d                   	pop    %ebp
80100fb0:	c3                   	ret    
80100fb1:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
80100fb4:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80100fb7:	75 e6                	jne    80100f9f <filewrite+0xcb>
}
80100fb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100fbc:	83 c4 2c             	add    $0x2c,%esp
80100fbf:	5b                   	pop    %ebx
80100fc0:	5e                   	pop    %esi
80100fc1:	5f                   	pop    %edi
80100fc2:	5d                   	pop    %ebp
80100fc3:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
80100fc4:	8b 47 0c             	mov    0xc(%edi),%eax
80100fc7:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fca:	83 c4 2c             	add    $0x2c,%esp
80100fcd:	5b                   	pop    %ebx
80100fce:	5e                   	pop    %esi
80100fcf:	5f                   	pop    %edi
80100fd0:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80100fd1:	e9 06 1f 00 00       	jmp    80102edc <pipewrite>
        panic("short filewrite");
80100fd6:	c7 04 24 cf 6c 10 80 	movl   $0x80106ccf,(%esp)
80100fdd:	e8 2e f3 ff ff       	call   80100310 <panic>
  panic("filewrite");
80100fe2:	c7 04 24 d5 6c 10 80 	movl   $0x80106cd5,(%esp)
80100fe9:	e8 22 f3 ff ff       	call   80100310 <panic>
80100fee:	66 90                	xchg   %ax,%ax

80100ff0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 2c             	sub    $0x2c,%esp
80100ff9:	89 c7                	mov    %eax,%edi
80100ffb:	89 d3                	mov    %edx,%ebx
  struct inode *ip, *empty;

  acquire(&icache.lock);
80100ffd:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101004:	e8 77 2c 00 00       	call   80103c80 <acquire>

  // Is the inode already cached?
  empty = 0;
80101009:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010100b:	b8 14 0a 11 80       	mov    $0x80110a14,%eax
80101010:	eb 12                	jmp    80101024 <iget+0x34>
80101012:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101014:	85 f6                	test   %esi,%esi
80101016:	74 3c                	je     80101054 <iget+0x64>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101018:	05 90 00 00 00       	add    $0x90,%eax
8010101d:	3d 34 26 11 80       	cmp    $0x80112634,%eax
80101022:	74 44                	je     80101068 <iget+0x78>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101024:	8b 48 08             	mov    0x8(%eax),%ecx
80101027:	85 c9                	test   %ecx,%ecx
80101029:	7e e9                	jle    80101014 <iget+0x24>
8010102b:	39 38                	cmp    %edi,(%eax)
8010102d:	75 e5                	jne    80101014 <iget+0x24>
8010102f:	39 58 04             	cmp    %ebx,0x4(%eax)
80101032:	75 e0                	jne    80101014 <iget+0x24>
      ip->ref++;
80101034:	41                   	inc    %ecx
80101035:	89 48 08             	mov    %ecx,0x8(%eax)
      release(&icache.lock);
80101038:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010103f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101042:	e8 f5 2c 00 00       	call   80103d3c <release>
      return ip;
80101047:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010104a:	83 c4 2c             	add    $0x2c,%esp
8010104d:	5b                   	pop    %ebx
8010104e:	5e                   	pop    %esi
8010104f:	5f                   	pop    %edi
80101050:	5d                   	pop    %ebp
80101051:	c3                   	ret    
80101052:	66 90                	xchg   %ax,%ax
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101054:	85 c9                	test   %ecx,%ecx
80101056:	75 c0                	jne    80101018 <iget+0x28>
80101058:	89 c6                	mov    %eax,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010105a:	05 90 00 00 00       	add    $0x90,%eax
8010105f:	3d 34 26 11 80       	cmp    $0x80112634,%eax
80101064:	75 be                	jne    80101024 <iget+0x34>
80101066:	66 90                	xchg   %ax,%ax
  if(empty == 0)
80101068:	85 f6                	test   %esi,%esi
8010106a:	74 29                	je     80101095 <iget+0xa5>
  ip->dev = dev;
8010106c:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
8010106e:	89 5e 04             	mov    %ebx,0x4(%esi)
  ip->ref = 1;
80101071:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101078:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010107f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101086:	e8 b1 2c 00 00       	call   80103d3c <release>
  return ip;
8010108b:	89 f0                	mov    %esi,%eax
}
8010108d:	83 c4 2c             	add    $0x2c,%esp
80101090:	5b                   	pop    %ebx
80101091:	5e                   	pop    %esi
80101092:	5f                   	pop    %edi
80101093:	5d                   	pop    %ebp
80101094:	c3                   	ret    
    panic("iget: no inodes");
80101095:	c7 04 24 df 6c 10 80 	movl   $0x80106cdf,(%esp)
8010109c:	e8 6f f2 ff ff       	call   80100310 <panic>
801010a1:	8d 76 00             	lea    0x0(%esi),%esi

801010a4 <balloc>:
{
801010a4:	55                   	push   %ebp
801010a5:	89 e5                	mov    %esp,%ebp
801010a7:	57                   	push   %edi
801010a8:	56                   	push   %esi
801010a9:	53                   	push   %ebx
801010aa:	83 ec 2c             	sub    $0x2c,%esp
801010ad:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801010b0:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801010b5:	85 c0                	test   %eax,%eax
801010b7:	0f 84 83 00 00 00    	je     80101140 <balloc+0x9c>
801010bd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801010c4:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010c7:	c1 f8 0c             	sar    $0xc,%eax
801010ca:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801010d0:	89 44 24 04          	mov    %eax,0x4(%esp)
801010d4:	8b 45 d8             	mov    -0x28(%ebp),%eax
801010d7:	89 04 24             	mov    %eax,(%esp)
801010da:	e8 d5 ef ff ff       	call   801000b4 <bread>
801010df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801010e2:	8b 15 c0 09 11 80    	mov    0x801109c0,%edx
801010e8:	89 55 e0             	mov    %edx,-0x20(%ebp)
801010eb:	8b 75 dc             	mov    -0x24(%ebp),%esi
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010ee:	31 c0                	xor    %eax,%eax
801010f0:	eb 2c                	jmp    8010111e <balloc+0x7a>
801010f2:	66 90                	xchg   %ax,%ax
      m = 1 << (bi % 8);
801010f4:	89 c1                	mov    %eax,%ecx
801010f6:	83 e1 07             	and    $0x7,%ecx
801010f9:	bf 01 00 00 00       	mov    $0x1,%edi
801010fe:	d3 e7                	shl    %cl,%edi
80101100:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101102:	89 c3                	mov    %eax,%ebx
80101104:	c1 fb 03             	sar    $0x3,%ebx
80101107:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010110a:	8a 54 1f 5c          	mov    0x5c(%edi,%ebx,1),%dl
8010110e:	0f b6 fa             	movzbl %dl,%edi
80101111:	85 cf                	test   %ecx,%edi
80101113:	74 37                	je     8010114c <balloc+0xa8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101115:	40                   	inc    %eax
80101116:	46                   	inc    %esi
80101117:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010111c:	74 05                	je     80101123 <balloc+0x7f>
8010111e:	39 75 e0             	cmp    %esi,-0x20(%ebp)
80101121:	77 d1                	ja     801010f4 <balloc+0x50>
    brelse(bp);
80101123:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101126:	89 04 24             	mov    %eax,(%esp)
80101129:	e8 7a f0 ff ff       	call   801001a8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010112e:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101135:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101138:	3b 15 c0 09 11 80    	cmp    0x801109c0,%edx
8010113e:	72 84                	jb     801010c4 <balloc+0x20>
  panic("balloc: out of blocks");
80101140:	c7 04 24 ef 6c 10 80 	movl   $0x80106cef,(%esp)
80101147:	e8 c4 f1 ff ff       	call   80100310 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
8010114c:	09 ca                	or     %ecx,%edx
8010114e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101151:	88 54 18 5c          	mov    %dl,0x5c(%eax,%ebx,1)
        log_write(bp);
80101155:	89 04 24             	mov    %eax,(%esp)
80101158:	e8 bf 17 00 00       	call   8010291c <log_write>
        brelse(bp);
8010115d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101160:	89 04 24             	mov    %eax,(%esp)
80101163:	e8 40 f0 ff ff       	call   801001a8 <brelse>
  bp = bread(dev, bno);
80101168:	89 74 24 04          	mov    %esi,0x4(%esp)
8010116c:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010116f:	89 04 24             	mov    %eax,(%esp)
80101172:	e8 3d ef ff ff       	call   801000b4 <bread>
80101177:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101179:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101180:	00 
80101181:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101188:	00 
80101189:	8d 40 5c             	lea    0x5c(%eax),%eax
8010118c:	89 04 24             	mov    %eax,(%esp)
8010118f:	e8 f0 2b 00 00       	call   80103d84 <memset>
  log_write(bp);
80101194:	89 1c 24             	mov    %ebx,(%esp)
80101197:	e8 80 17 00 00       	call   8010291c <log_write>
  brelse(bp);
8010119c:	89 1c 24             	mov    %ebx,(%esp)
8010119f:	e8 04 f0 ff ff       	call   801001a8 <brelse>
}
801011a4:	89 f0                	mov    %esi,%eax
801011a6:	83 c4 2c             	add    $0x2c,%esp
801011a9:	5b                   	pop    %ebx
801011aa:	5e                   	pop    %esi
801011ab:	5f                   	pop    %edi
801011ac:	5d                   	pop    %ebp
801011ad:	c3                   	ret    
801011ae:	66 90                	xchg   %ax,%ax

801011b0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	57                   	push   %edi
801011b4:	56                   	push   %esi
801011b5:	53                   	push   %ebx
801011b6:	83 ec 2c             	sub    $0x2c,%esp
801011b9:	89 c6                	mov    %eax,%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801011bb:	83 fa 0b             	cmp    $0xb,%edx
801011be:	77 14                	ja     801011d4 <bmap+0x24>
    if((addr = ip->addrs[bn]) == 0)
801011c0:	8d 7a 14             	lea    0x14(%edx),%edi
801011c3:	8b 44 b8 0c          	mov    0xc(%eax,%edi,4),%eax
801011c7:	85 c0                	test   %eax,%eax
801011c9:	74 65                	je     80101230 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801011cb:	83 c4 2c             	add    $0x2c,%esp
801011ce:	5b                   	pop    %ebx
801011cf:	5e                   	pop    %esi
801011d0:	5f                   	pop    %edi
801011d1:	5d                   	pop    %ebp
801011d2:	c3                   	ret    
801011d3:	90                   	nop
  bn -= NDIRECT;
801011d4:	8d 5a f4             	lea    -0xc(%edx),%ebx
  if(bn < NINDIRECT){
801011d7:	83 fb 7f             	cmp    $0x7f,%ebx
801011da:	77 77                	ja     80101253 <bmap+0xa3>
    if((addr = ip->addrs[NDIRECT]) == 0)
801011dc:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801011e2:	85 c0                	test   %eax,%eax
801011e4:	74 5e                	je     80101244 <bmap+0x94>
    bp = bread(ip->dev, addr);
801011e6:	89 44 24 04          	mov    %eax,0x4(%esp)
801011ea:	8b 06                	mov    (%esi),%eax
801011ec:	89 04 24             	mov    %eax,(%esp)
801011ef:	e8 c0 ee ff ff       	call   801000b4 <bread>
801011f4:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801011f6:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
801011fa:	8b 03                	mov    (%ebx),%eax
801011fc:	85 c0                	test   %eax,%eax
801011fe:	75 17                	jne    80101217 <bmap+0x67>
      a[bn] = addr = balloc(ip->dev);
80101200:	8b 06                	mov    (%esi),%eax
80101202:	e8 9d fe ff ff       	call   801010a4 <balloc>
80101207:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101209:	89 3c 24             	mov    %edi,(%esp)
8010120c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010120f:	e8 08 17 00 00       	call   8010291c <log_write>
80101214:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    brelse(bp);
80101217:	89 3c 24             	mov    %edi,(%esp)
8010121a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010121d:	e8 86 ef ff ff       	call   801001a8 <brelse>
80101222:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101225:	83 c4 2c             	add    $0x2c,%esp
80101228:	5b                   	pop    %ebx
80101229:	5e                   	pop    %esi
8010122a:	5f                   	pop    %edi
8010122b:	5d                   	pop    %ebp
8010122c:	c3                   	ret    
8010122d:	8d 76 00             	lea    0x0(%esi),%esi
      ip->addrs[bn] = addr = balloc(ip->dev);
80101230:	8b 06                	mov    (%esi),%eax
80101232:	e8 6d fe ff ff       	call   801010a4 <balloc>
80101237:	89 44 be 0c          	mov    %eax,0xc(%esi,%edi,4)
}
8010123b:	83 c4 2c             	add    $0x2c,%esp
8010123e:	5b                   	pop    %ebx
8010123f:	5e                   	pop    %esi
80101240:	5f                   	pop    %edi
80101241:	5d                   	pop    %ebp
80101242:	c3                   	ret    
80101243:	90                   	nop
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101244:	8b 06                	mov    (%esi),%eax
80101246:	e8 59 fe ff ff       	call   801010a4 <balloc>
8010124b:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101251:	eb 93                	jmp    801011e6 <bmap+0x36>
  panic("bmap: out of range");
80101253:	c7 04 24 05 6d 10 80 	movl   $0x80106d05,(%esp)
8010125a:	e8 b1 f0 ff ff       	call   80100310 <panic>
8010125f:	90                   	nop

80101260 <readsb>:
{
80101260:	55                   	push   %ebp
80101261:	89 e5                	mov    %esp,%ebp
80101263:	56                   	push   %esi
80101264:	53                   	push   %ebx
80101265:	83 ec 10             	sub    $0x10,%esp
80101268:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
8010126b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101272:	00 
80101273:	8b 45 08             	mov    0x8(%ebp),%eax
80101276:	89 04 24             	mov    %eax,(%esp)
80101279:	e8 36 ee ff ff       	call   801000b4 <bread>
8010127e:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101280:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101287:	00 
80101288:	8d 40 5c             	lea    0x5c(%eax),%eax
8010128b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010128f:	89 34 24             	mov    %esi,(%esp)
80101292:	e8 81 2b 00 00       	call   80103e18 <memmove>
  brelse(bp);
80101297:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010129a:	83 c4 10             	add    $0x10,%esp
8010129d:	5b                   	pop    %ebx
8010129e:	5e                   	pop    %esi
8010129f:	5d                   	pop    %ebp
  brelse(bp);
801012a0:	e9 03 ef ff ff       	jmp    801001a8 <brelse>
801012a5:	8d 76 00             	lea    0x0(%esi),%esi

801012a8 <bfree>:
{
801012a8:	55                   	push   %ebp
801012a9:	89 e5                	mov    %esp,%ebp
801012ab:	57                   	push   %edi
801012ac:	56                   	push   %esi
801012ad:	53                   	push   %ebx
801012ae:	83 ec 1c             	sub    $0x1c,%esp
801012b1:	89 c3                	mov    %eax,%ebx
801012b3:	89 d7                	mov    %edx,%edi
  readsb(dev, &sb);
801012b5:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801012bc:	80 
801012bd:	89 04 24             	mov    %eax,(%esp)
801012c0:	e8 9b ff ff ff       	call   80101260 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
801012c5:	89 fa                	mov    %edi,%edx
801012c7:	c1 ea 0c             	shr    $0xc,%edx
801012ca:	03 15 d8 09 11 80    	add    0x801109d8,%edx
801012d0:	89 54 24 04          	mov    %edx,0x4(%esp)
801012d4:	89 1c 24             	mov    %ebx,(%esp)
801012d7:	e8 d8 ed ff ff       	call   801000b4 <bread>
801012dc:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
801012de:	89 f9                	mov    %edi,%ecx
801012e0:	83 e1 07             	and    $0x7,%ecx
801012e3:	bb 01 00 00 00       	mov    $0x1,%ebx
801012e8:	d3 e3                	shl    %cl,%ebx
  bi = b % BPB;
801012ea:	89 fa                	mov    %edi,%edx
801012ec:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  if((bp->data[bi/8] & m) == 0)
801012f2:	c1 fa 03             	sar    $0x3,%edx
801012f5:	8a 44 10 5c          	mov    0x5c(%eax,%edx,1),%al
801012f9:	0f b6 c8             	movzbl %al,%ecx
801012fc:	85 d9                	test   %ebx,%ecx
801012fe:	74 20                	je     80101320 <bfree+0x78>
  bp->data[bi/8] &= ~m;
80101300:	f7 d3                	not    %ebx
80101302:	21 c3                	and    %eax,%ebx
80101304:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101308:	89 34 24             	mov    %esi,(%esp)
8010130b:	e8 0c 16 00 00       	call   8010291c <log_write>
  brelse(bp);
80101310:	89 34 24             	mov    %esi,(%esp)
80101313:	e8 90 ee ff ff       	call   801001a8 <brelse>
}
80101318:	83 c4 1c             	add    $0x1c,%esp
8010131b:	5b                   	pop    %ebx
8010131c:	5e                   	pop    %esi
8010131d:	5f                   	pop    %edi
8010131e:	5d                   	pop    %ebp
8010131f:	c3                   	ret    
    panic("freeing free block");
80101320:	c7 04 24 18 6d 10 80 	movl   $0x80106d18,(%esp)
80101327:	e8 e4 ef ff ff       	call   80100310 <panic>

8010132c <iinit>:
{
8010132c:	55                   	push   %ebp
8010132d:	89 e5                	mov    %esp,%ebp
8010132f:	53                   	push   %ebx
80101330:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
80101333:	c7 44 24 04 2b 6d 10 	movl   $0x80106d2b,0x4(%esp)
8010133a:	80 
8010133b:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101342:	e8 71 28 00 00       	call   80103bb8 <initlock>
  for(i = 0; i < NINODE; i++) {
80101347:	31 db                	xor    %ebx,%ebx
80101349:	8d 76 00             	lea    0x0(%esi),%esi
    initsleeplock(&icache.inode[i].lock, "inode");
8010134c:	c7 44 24 04 32 6d 10 	movl   $0x80106d32,0x4(%esp)
80101353:	80 
80101354:	8d 04 db             	lea    (%ebx,%ebx,8),%eax
80101357:	c1 e0 04             	shl    $0x4,%eax
8010135a:	05 20 0a 11 80       	add    $0x80110a20,%eax
8010135f:	89 04 24             	mov    %eax,(%esp)
80101362:	e8 61 27 00 00       	call   80103ac8 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101367:	43                   	inc    %ebx
80101368:	83 fb 32             	cmp    $0x32,%ebx
8010136b:	75 df                	jne    8010134c <iinit+0x20>
  readsb(dev, &sb);
8010136d:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80101374:	80 
80101375:	8b 45 08             	mov    0x8(%ebp),%eax
80101378:	89 04 24             	mov    %eax,(%esp)
8010137b:	e8 e0 fe ff ff       	call   80101260 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101380:	a1 d8 09 11 80       	mov    0x801109d8,%eax
80101385:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101389:	a1 d4 09 11 80       	mov    0x801109d4,%eax
8010138e:	89 44 24 18          	mov    %eax,0x18(%esp)
80101392:	a1 d0 09 11 80       	mov    0x801109d0,%eax
80101397:	89 44 24 14          	mov    %eax,0x14(%esp)
8010139b:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801013a0:	89 44 24 10          	mov    %eax,0x10(%esp)
801013a4:	a1 c8 09 11 80       	mov    0x801109c8,%eax
801013a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
801013ad:	a1 c4 09 11 80       	mov    0x801109c4,%eax
801013b2:	89 44 24 08          	mov    %eax,0x8(%esp)
801013b6:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801013bb:	89 44 24 04          	mov    %eax,0x4(%esp)
801013bf:	c7 04 24 98 6d 10 80 	movl   $0x80106d98,(%esp)
801013c6:	e8 e9 f1 ff ff       	call   801005b4 <cprintf>
}
801013cb:	83 c4 24             	add    $0x24,%esp
801013ce:	5b                   	pop    %ebx
801013cf:	5d                   	pop    %ebp
801013d0:	c3                   	ret    
801013d1:	8d 76 00             	lea    0x0(%esi),%esi

801013d4 <ialloc>:
{
801013d4:	55                   	push   %ebp
801013d5:	89 e5                	mov    %esp,%ebp
801013d7:	57                   	push   %edi
801013d8:	56                   	push   %esi
801013d9:	53                   	push   %ebx
801013da:	83 ec 2c             	sub    $0x2c,%esp
801013dd:	8b 45 08             	mov    0x8(%ebp),%eax
801013e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801013e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801013e6:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801013ea:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
801013f1:	0f 86 94 00 00 00    	jbe    8010148b <ialloc+0xb7>
801013f7:	bf 01 00 00 00       	mov    $0x1,%edi
801013fc:	bb 01 00 00 00       	mov    $0x1,%ebx
80101401:	eb 14                	jmp    80101417 <ialloc+0x43>
80101403:	90                   	nop
    brelse(bp);
80101404:	89 34 24             	mov    %esi,(%esp)
80101407:	e8 9c ed ff ff       	call   801001a8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010140c:	43                   	inc    %ebx
8010140d:	89 df                	mov    %ebx,%edi
8010140f:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101415:	73 74                	jae    8010148b <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
80101417:	89 f8                	mov    %edi,%eax
80101419:	c1 e8 03             	shr    $0x3,%eax
8010141c:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101422:	89 44 24 04          	mov    %eax,0x4(%esp)
80101426:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101429:	89 04 24             	mov    %eax,(%esp)
8010142c:	e8 83 ec ff ff       	call   801000b4 <bread>
80101431:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
80101433:	89 d8                	mov    %ebx,%eax
80101435:	83 e0 07             	and    $0x7,%eax
80101438:	c1 e0 06             	shl    $0x6,%eax
8010143b:	8d 4c 06 5c          	lea    0x5c(%esi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010143f:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101443:	75 bf                	jne    80101404 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101445:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
8010144c:	00 
8010144d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80101454:	00 
80101455:	89 0c 24             	mov    %ecx,(%esp)
80101458:	89 4d dc             	mov    %ecx,-0x24(%ebp)
8010145b:	e8 24 29 00 00       	call   80103d84 <memset>
      dip->type = type;
80101460:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80101463:	66 8b 45 e2          	mov    -0x1e(%ebp),%ax
80101467:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010146a:	89 34 24             	mov    %esi,(%esp)
8010146d:	e8 aa 14 00 00       	call   8010291c <log_write>
      brelse(bp);
80101472:	89 34 24             	mov    %esi,(%esp)
80101475:	e8 2e ed ff ff       	call   801001a8 <brelse>
      return iget(dev, inum);
8010147a:	89 fa                	mov    %edi,%edx
8010147c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
8010147f:	83 c4 2c             	add    $0x2c,%esp
80101482:	5b                   	pop    %ebx
80101483:	5e                   	pop    %esi
80101484:	5f                   	pop    %edi
80101485:	5d                   	pop    %ebp
      return iget(dev, inum);
80101486:	e9 65 fb ff ff       	jmp    80100ff0 <iget>
  panic("ialloc: no inodes");
8010148b:	c7 04 24 38 6d 10 80 	movl   $0x80106d38,(%esp)
80101492:	e8 79 ee ff ff       	call   80100310 <panic>
80101497:	90                   	nop

80101498 <iupdate>:
{
80101498:	55                   	push   %ebp
80101499:	89 e5                	mov    %esp,%ebp
8010149b:	56                   	push   %esi
8010149c:	53                   	push   %ebx
8010149d:	83 ec 10             	sub    $0x10,%esp
801014a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801014a3:	8b 43 04             	mov    0x4(%ebx),%eax
801014a6:	c1 e8 03             	shr    $0x3,%eax
801014a9:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801014af:	89 44 24 04          	mov    %eax,0x4(%esp)
801014b3:	8b 03                	mov    (%ebx),%eax
801014b5:	89 04 24             	mov    %eax,(%esp)
801014b8:	e8 f7 eb ff ff       	call   801000b4 <bread>
801014bd:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801014bf:	8b 53 04             	mov    0x4(%ebx),%edx
801014c2:	83 e2 07             	and    $0x7,%edx
801014c5:	c1 e2 06             	shl    $0x6,%edx
801014c8:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
  dip->type = ip->type;
801014cc:	8b 43 50             	mov    0x50(%ebx),%eax
801014cf:	66 89 02             	mov    %ax,(%edx)
  dip->major = ip->major;
801014d2:	66 8b 43 52          	mov    0x52(%ebx),%ax
801014d6:	66 89 42 02          	mov    %ax,0x2(%edx)
  dip->minor = ip->minor;
801014da:	8b 43 54             	mov    0x54(%ebx),%eax
801014dd:	66 89 42 04          	mov    %ax,0x4(%edx)
  dip->nlink = ip->nlink;
801014e1:	66 8b 43 56          	mov    0x56(%ebx),%ax
801014e5:	66 89 42 06          	mov    %ax,0x6(%edx)
  dip->size = ip->size;
801014e9:	8b 43 58             	mov    0x58(%ebx),%eax
801014ec:	89 42 08             	mov    %eax,0x8(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801014ef:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801014f6:	00 
801014f7:	83 c3 5c             	add    $0x5c,%ebx
801014fa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801014fe:	83 c2 0c             	add    $0xc,%edx
80101501:	89 14 24             	mov    %edx,(%esp)
80101504:	e8 0f 29 00 00       	call   80103e18 <memmove>
  log_write(bp);
80101509:	89 34 24             	mov    %esi,(%esp)
8010150c:	e8 0b 14 00 00       	call   8010291c <log_write>
  brelse(bp);
80101511:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101514:	83 c4 10             	add    $0x10,%esp
80101517:	5b                   	pop    %ebx
80101518:	5e                   	pop    %esi
80101519:	5d                   	pop    %ebp
  brelse(bp);
8010151a:	e9 89 ec ff ff       	jmp    801001a8 <brelse>
8010151f:	90                   	nop

80101520 <idup>:
{
80101520:	55                   	push   %ebp
80101521:	89 e5                	mov    %esp,%ebp
80101523:	53                   	push   %ebx
80101524:	83 ec 14             	sub    $0x14,%esp
80101527:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010152a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101531:	e8 4a 27 00 00       	call   80103c80 <acquire>
  ip->ref++;
80101536:	ff 43 08             	incl   0x8(%ebx)
  release(&icache.lock);
80101539:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101540:	e8 f7 27 00 00       	call   80103d3c <release>
}
80101545:	89 d8                	mov    %ebx,%eax
80101547:	83 c4 14             	add    $0x14,%esp
8010154a:	5b                   	pop    %ebx
8010154b:	5d                   	pop    %ebp
8010154c:	c3                   	ret    
8010154d:	8d 76 00             	lea    0x0(%esi),%esi

80101550 <ilock>:
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	56                   	push   %esi
80101554:	53                   	push   %ebx
80101555:	83 ec 10             	sub    $0x10,%esp
80101558:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010155b:	85 db                	test   %ebx,%ebx
8010155d:	0f 84 b1 00 00 00    	je     80101614 <ilock+0xc4>
80101563:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101566:	85 c9                	test   %ecx,%ecx
80101568:	0f 8e a6 00 00 00    	jle    80101614 <ilock+0xc4>
  acquiresleep(&ip->lock);
8010156e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101571:	89 04 24             	mov    %eax,(%esp)
80101574:	e8 87 25 00 00       	call   80103b00 <acquiresleep>
  if(ip->valid == 0){
80101579:	8b 53 4c             	mov    0x4c(%ebx),%edx
8010157c:	85 d2                	test   %edx,%edx
8010157e:	74 08                	je     80101588 <ilock+0x38>
}
80101580:	83 c4 10             	add    $0x10,%esp
80101583:	5b                   	pop    %ebx
80101584:	5e                   	pop    %esi
80101585:	5d                   	pop    %ebp
80101586:	c3                   	ret    
80101587:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101588:	8b 43 04             	mov    0x4(%ebx),%eax
8010158b:	c1 e8 03             	shr    $0x3,%eax
8010158e:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101594:	89 44 24 04          	mov    %eax,0x4(%esp)
80101598:	8b 03                	mov    (%ebx),%eax
8010159a:	89 04 24             	mov    %eax,(%esp)
8010159d:	e8 12 eb ff ff       	call   801000b4 <bread>
801015a2:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801015a4:	8b 53 04             	mov    0x4(%ebx),%edx
801015a7:	83 e2 07             	and    $0x7,%edx
801015aa:	c1 e2 06             	shl    $0x6,%edx
801015ad:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    ip->type = dip->type;
801015b1:	8b 02                	mov    (%edx),%eax
801015b3:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
801015b7:	66 8b 42 02          	mov    0x2(%edx),%ax
801015bb:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
801015bf:	8b 42 04             	mov    0x4(%edx),%eax
801015c2:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
801015c6:	66 8b 42 06          	mov    0x6(%edx),%ax
801015ca:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
801015ce:	8b 42 08             	mov    0x8(%edx),%eax
801015d1:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801015d4:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801015db:	00 
801015dc:	83 c2 0c             	add    $0xc,%edx
801015df:	89 54 24 04          	mov    %edx,0x4(%esp)
801015e3:	8d 43 5c             	lea    0x5c(%ebx),%eax
801015e6:	89 04 24             	mov    %eax,(%esp)
801015e9:	e8 2a 28 00 00       	call   80103e18 <memmove>
    brelse(bp);
801015ee:	89 34 24             	mov    %esi,(%esp)
801015f1:	e8 b2 eb ff ff       	call   801001a8 <brelse>
    ip->valid = 1;
801015f6:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801015fd:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
80101602:	0f 85 78 ff ff ff    	jne    80101580 <ilock+0x30>
      panic("ilock: no type");
80101608:	c7 04 24 50 6d 10 80 	movl   $0x80106d50,(%esp)
8010160f:	e8 fc ec ff ff       	call   80100310 <panic>
    panic("ilock");
80101614:	c7 04 24 4a 6d 10 80 	movl   $0x80106d4a,(%esp)
8010161b:	e8 f0 ec ff ff       	call   80100310 <panic>

80101620 <iunlock>:
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	56                   	push   %esi
80101624:	53                   	push   %ebx
80101625:	83 ec 10             	sub    $0x10,%esp
80101628:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010162b:	85 db                	test   %ebx,%ebx
8010162d:	74 24                	je     80101653 <iunlock+0x33>
8010162f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101632:	89 34 24             	mov    %esi,(%esp)
80101635:	e8 52 25 00 00       	call   80103b8c <holdingsleep>
8010163a:	85 c0                	test   %eax,%eax
8010163c:	74 15                	je     80101653 <iunlock+0x33>
8010163e:	8b 5b 08             	mov    0x8(%ebx),%ebx
80101641:	85 db                	test   %ebx,%ebx
80101643:	7e 0e                	jle    80101653 <iunlock+0x33>
  releasesleep(&ip->lock);
80101645:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101648:	83 c4 10             	add    $0x10,%esp
8010164b:	5b                   	pop    %ebx
8010164c:	5e                   	pop    %esi
8010164d:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010164e:	e9 fd 24 00 00       	jmp    80103b50 <releasesleep>
    panic("iunlock");
80101653:	c7 04 24 5f 6d 10 80 	movl   $0x80106d5f,(%esp)
8010165a:	e8 b1 ec ff ff       	call   80100310 <panic>
8010165f:	90                   	nop

80101660 <iput>:
{
80101660:	55                   	push   %ebp
80101661:	89 e5                	mov    %esp,%ebp
80101663:	57                   	push   %edi
80101664:	56                   	push   %esi
80101665:	53                   	push   %ebx
80101666:	83 ec 2c             	sub    $0x2c,%esp
80101669:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010166c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010166f:	89 3c 24             	mov    %edi,(%esp)
80101672:	e8 89 24 00 00       	call   80103b00 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101677:	8b 46 4c             	mov    0x4c(%esi),%eax
8010167a:	85 c0                	test   %eax,%eax
8010167c:	74 07                	je     80101685 <iput+0x25>
8010167e:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101683:	74 2b                	je     801016b0 <iput+0x50>
  releasesleep(&ip->lock);
80101685:	89 3c 24             	mov    %edi,(%esp)
80101688:	e8 c3 24 00 00       	call   80103b50 <releasesleep>
  acquire(&icache.lock);
8010168d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101694:	e8 e7 25 00 00       	call   80103c80 <acquire>
  ip->ref--;
80101699:	ff 4e 08             	decl   0x8(%esi)
  release(&icache.lock);
8010169c:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
801016a3:	83 c4 2c             	add    $0x2c,%esp
801016a6:	5b                   	pop    %ebx
801016a7:	5e                   	pop    %esi
801016a8:	5f                   	pop    %edi
801016a9:	5d                   	pop    %ebp
  release(&icache.lock);
801016aa:	e9 8d 26 00 00       	jmp    80103d3c <release>
801016af:	90                   	nop
    acquire(&icache.lock);
801016b0:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016b7:	e8 c4 25 00 00       	call   80103c80 <acquire>
    int r = ip->ref;
801016bc:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
801016bf:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016c6:	e8 71 26 00 00       	call   80103d3c <release>
    if(r == 1){
801016cb:	4b                   	dec    %ebx
801016cc:	75 b7                	jne    80101685 <iput+0x25>
801016ce:	89 f3                	mov    %esi,%ebx
iput(struct inode *ip)
801016d0:	8d 4e 30             	lea    0x30(%esi),%ecx
801016d3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801016d6:	89 cf                	mov    %ecx,%edi
801016d8:	eb 09                	jmp    801016e3 <iput+0x83>
801016da:	66 90                	xchg   %ax,%ax
801016dc:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801016df:	39 fb                	cmp    %edi,%ebx
801016e1:	74 19                	je     801016fc <iput+0x9c>
    if(ip->addrs[i]){
801016e3:	8b 53 5c             	mov    0x5c(%ebx),%edx
801016e6:	85 d2                	test   %edx,%edx
801016e8:	74 f2                	je     801016dc <iput+0x7c>
      bfree(ip->dev, ip->addrs[i]);
801016ea:	8b 06                	mov    (%esi),%eax
801016ec:	e8 b7 fb ff ff       	call   801012a8 <bfree>
      ip->addrs[i] = 0;
801016f1:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
801016f8:	eb e2                	jmp    801016dc <iput+0x7c>
801016fa:	66 90                	xchg   %ax,%ax
801016fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    }
  }

  if(ip->addrs[NDIRECT]){
801016ff:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101705:	85 c0                	test   %eax,%eax
80101707:	75 2b                	jne    80101734 <iput+0xd4>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101709:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101710:	89 34 24             	mov    %esi,(%esp)
80101713:	e8 80 fd ff ff       	call   80101498 <iupdate>
      ip->type = 0;
80101718:	66 c7 46 50 00 00    	movw   $0x0,0x50(%esi)
      iupdate(ip);
8010171e:	89 34 24             	mov    %esi,(%esp)
80101721:	e8 72 fd ff ff       	call   80101498 <iupdate>
      ip->valid = 0;
80101726:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
8010172d:	e9 53 ff ff ff       	jmp    80101685 <iput+0x25>
80101732:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101734:	89 44 24 04          	mov    %eax,0x4(%esp)
80101738:	8b 06                	mov    (%esi),%eax
8010173a:	89 04 24             	mov    %eax,(%esp)
8010173d:	e8 72 e9 ff ff       	call   801000b4 <bread>
80101742:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101745:	89 c1                	mov    %eax,%ecx
80101747:	83 c1 5c             	add    $0x5c,%ecx
    for(j = 0; j < NINDIRECT; j++){
8010174a:	31 db                	xor    %ebx,%ebx
8010174c:	31 c0                	xor    %eax,%eax
8010174e:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101751:	89 cf                	mov    %ecx,%edi
80101753:	eb 0e                	jmp    80101763 <iput+0x103>
80101755:	8d 76 00             	lea    0x0(%esi),%esi
80101758:	43                   	inc    %ebx
80101759:	89 d8                	mov    %ebx,%eax
8010175b:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101761:	74 10                	je     80101773 <iput+0x113>
      if(a[j])
80101763:	8b 14 87             	mov    (%edi,%eax,4),%edx
80101766:	85 d2                	test   %edx,%edx
80101768:	74 ee                	je     80101758 <iput+0xf8>
        bfree(ip->dev, a[j]);
8010176a:	8b 06                	mov    (%esi),%eax
8010176c:	e8 37 fb ff ff       	call   801012a8 <bfree>
80101771:	eb e5                	jmp    80101758 <iput+0xf8>
80101773:	8b 7d e0             	mov    -0x20(%ebp),%edi
    brelse(bp);
80101776:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101779:	89 04 24             	mov    %eax,(%esp)
8010177c:	e8 27 ea ff ff       	call   801001a8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101781:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101787:	8b 06                	mov    (%esi),%eax
80101789:	e8 1a fb ff ff       	call   801012a8 <bfree>
    ip->addrs[NDIRECT] = 0;
8010178e:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101795:	00 00 00 
80101798:	e9 6c ff ff ff       	jmp    80101709 <iput+0xa9>
8010179d:	8d 76 00             	lea    0x0(%esi),%esi

801017a0 <iunlockput>:
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	53                   	push   %ebx
801017a4:	83 ec 14             	sub    $0x14,%esp
801017a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801017aa:	89 1c 24             	mov    %ebx,(%esp)
801017ad:	e8 6e fe ff ff       	call   80101620 <iunlock>
  iput(ip);
801017b2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801017b5:	83 c4 14             	add    $0x14,%esp
801017b8:	5b                   	pop    %ebx
801017b9:	5d                   	pop    %ebp
  iput(ip);
801017ba:	e9 a1 fe ff ff       	jmp    80101660 <iput>
801017bf:	90                   	nop

801017c0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	8b 55 08             	mov    0x8(%ebp),%edx
801017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801017c9:	8b 0a                	mov    (%edx),%ecx
801017cb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801017ce:	8b 4a 04             	mov    0x4(%edx),%ecx
801017d1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801017d4:	8b 4a 50             	mov    0x50(%edx),%ecx
801017d7:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801017da:	66 8b 4a 56          	mov    0x56(%edx),%cx
801017de:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801017e2:	8b 52 58             	mov    0x58(%edx),%edx
801017e5:	89 50 10             	mov    %edx,0x10(%eax)
}
801017e8:	5d                   	pop    %ebp
801017e9:	c3                   	ret    
801017ea:	66 90                	xchg   %ax,%ax

801017ec <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
801017ec:	55                   	push   %ebp
801017ed:	89 e5                	mov    %esp,%ebp
801017ef:	57                   	push   %edi
801017f0:	56                   	push   %esi
801017f1:	53                   	push   %ebx
801017f2:	83 ec 2c             	sub    $0x2c,%esp
801017f5:	8b 7d 08             	mov    0x8(%ebp),%edi
801017f8:	8b 45 0c             	mov    0xc(%ebp),%eax
801017fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
801017fe:	8b 75 10             	mov    0x10(%ebp),%esi
80101801:	8b 55 14             	mov    0x14(%ebp),%edx
80101804:	89 55 dc             	mov    %edx,-0x24(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101807:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
8010180c:	0f 84 b2 00 00 00    	je     801018c4 <readi+0xd8>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101812:	8b 47 58             	mov    0x58(%edi),%eax
80101815:	39 f0                	cmp    %esi,%eax
80101817:	0f 82 cb 00 00 00    	jb     801018e8 <readi+0xfc>
8010181d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101820:	01 f2                	add    %esi,%edx
80101822:	0f 82 c0 00 00 00    	jb     801018e8 <readi+0xfc>
    return -1;
  if(off + n > ip->size)
80101828:	39 d0                	cmp    %edx,%eax
8010182a:	0f 82 88 00 00 00    	jb     801018b8 <readi+0xcc>
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101830:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101837:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010183a:	85 c0                	test   %eax,%eax
8010183c:	74 6d                	je     801018ab <readi+0xbf>
8010183e:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101840:	89 f2                	mov    %esi,%edx
80101842:	c1 ea 09             	shr    $0x9,%edx
80101845:	89 f8                	mov    %edi,%eax
80101847:	e8 64 f9 ff ff       	call   801011b0 <bmap>
8010184c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101850:	8b 07                	mov    (%edi),%eax
80101852:	89 04 24             	mov    %eax,(%esp)
80101855:	e8 5a e8 ff ff       	call   801000b4 <bread>
8010185a:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
8010185c:	89 f0                	mov    %esi,%eax
8010185e:	25 ff 01 00 00       	and    $0x1ff,%eax
80101863:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80101866:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
80101869:	bb 00 02 00 00       	mov    $0x200,%ebx
8010186e:	29 c3                	sub    %eax,%ebx
80101870:	39 cb                	cmp    %ecx,%ebx
80101872:	76 02                	jbe    80101876 <readi+0x8a>
80101874:	89 cb                	mov    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101876:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010187a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
8010187e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101882:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101885:	89 04 24             	mov    %eax,(%esp)
80101888:	89 55 d8             	mov    %edx,-0x28(%ebp)
8010188b:	e8 88 25 00 00       	call   80103e18 <memmove>
    brelse(bp);
80101890:	8b 55 d8             	mov    -0x28(%ebp),%edx
80101893:	89 14 24             	mov    %edx,(%esp)
80101896:	e8 0d e9 ff ff       	call   801001a8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010189b:	01 5d e4             	add    %ebx,-0x1c(%ebp)
8010189e:	01 de                	add    %ebx,%esi
801018a0:	01 5d e0             	add    %ebx,-0x20(%ebp)
801018a3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801018a6:	39 55 dc             	cmp    %edx,-0x24(%ebp)
801018a9:	77 95                	ja     80101840 <readi+0x54>
  }
  return n;
801018ab:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
801018ae:	83 c4 2c             	add    $0x2c,%esp
801018b1:	5b                   	pop    %ebx
801018b2:	5e                   	pop    %esi
801018b3:	5f                   	pop    %edi
801018b4:	5d                   	pop    %ebp
801018b5:	c3                   	ret    
801018b6:	66 90                	xchg   %ax,%ax
    n = ip->size - off;
801018b8:	29 f0                	sub    %esi,%eax
801018ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
801018bd:	e9 6e ff ff ff       	jmp    80101830 <readi+0x44>
801018c2:	66 90                	xchg   %ax,%ax
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
801018c4:	0f bf 47 52          	movswl 0x52(%edi),%eax
801018c8:	66 83 f8 09          	cmp    $0x9,%ax
801018cc:	77 1a                	ja     801018e8 <readi+0xfc>
801018ce:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
801018d5:	85 c0                	test   %eax,%eax
801018d7:	74 0f                	je     801018e8 <readi+0xfc>
    return devsw[ip->major].read(ip, dst, n);
801018d9:	89 55 10             	mov    %edx,0x10(%ebp)
}
801018dc:	83 c4 2c             	add    $0x2c,%esp
801018df:	5b                   	pop    %ebx
801018e0:	5e                   	pop    %esi
801018e1:	5f                   	pop    %edi
801018e2:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
801018e3:	ff e0                	jmp    *%eax
801018e5:	8d 76 00             	lea    0x0(%esi),%esi
      return -1;
801018e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018ed:	eb bf                	jmp    801018ae <readi+0xc2>
801018ef:	90                   	nop

801018f0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
801018f0:	55                   	push   %ebp
801018f1:	89 e5                	mov    %esp,%ebp
801018f3:	57                   	push   %edi
801018f4:	56                   	push   %esi
801018f5:	53                   	push   %ebx
801018f6:	83 ec 2c             	sub    $0x2c,%esp
801018f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801018fc:	8b 45 0c             	mov    0xc(%ebp),%eax
801018ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101902:	8b 55 10             	mov    0x10(%ebp),%edx
80101905:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101908:	8b 45 14             	mov    0x14(%ebp),%eax
8010190b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010190e:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
80101913:	0f 84 b7 00 00 00    	je     801019d0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101919:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010191c:	39 47 58             	cmp    %eax,0x58(%edi)
8010191f:	0f 82 df 00 00 00    	jb     80101a04 <writei+0x114>
80101925:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101928:	03 45 e4             	add    -0x1c(%ebp),%eax
8010192b:	0f 82 d3 00 00 00    	jb     80101a04 <writei+0x114>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101931:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101936:	0f 87 c8 00 00 00    	ja     80101a04 <writei+0x114>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010193c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80101943:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101946:	85 c0                	test   %eax,%eax
80101948:	74 7a                	je     801019c4 <writei+0xd4>
8010194a:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010194c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010194f:	c1 ea 09             	shr    $0x9,%edx
80101952:	89 f8                	mov    %edi,%eax
80101954:	e8 57 f8 ff ff       	call   801011b0 <bmap>
80101959:	89 44 24 04          	mov    %eax,0x4(%esp)
8010195d:	8b 07                	mov    (%edi),%eax
8010195f:	89 04 24             	mov    %eax,(%esp)
80101962:	e8 4d e7 ff ff       	call   801000b4 <bread>
80101967:	89 c6                	mov    %eax,%esi
    m = min(n - tot, BSIZE - off%BSIZE);
80101969:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010196c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101971:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80101974:	2b 4d e0             	sub    -0x20(%ebp),%ecx
80101977:	bb 00 02 00 00       	mov    $0x200,%ebx
8010197c:	29 c3                	sub    %eax,%ebx
8010197e:	39 cb                	cmp    %ecx,%ebx
80101980:	76 02                	jbe    80101984 <writei+0x94>
80101982:	89 cb                	mov    %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101984:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101988:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010198b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010198f:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
80101993:	89 04 24             	mov    %eax,(%esp)
80101996:	e8 7d 24 00 00       	call   80103e18 <memmove>
    log_write(bp);
8010199b:	89 34 24             	mov    %esi,(%esp)
8010199e:	e8 79 0f 00 00       	call   8010291c <log_write>
    brelse(bp);
801019a3:	89 34 24             	mov    %esi,(%esp)
801019a6:	e8 fd e7 ff ff       	call   801001a8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801019ab:	01 5d e0             	add    %ebx,-0x20(%ebp)
801019ae:	01 5d e4             	add    %ebx,-0x1c(%ebp)
801019b1:	01 5d dc             	add    %ebx,-0x24(%ebp)
801019b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801019b7:	39 45 d8             	cmp    %eax,-0x28(%ebp)
801019ba:	77 90                	ja     8010194c <writei+0x5c>
  }

  if(n > 0 && off > ip->size){
801019bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019bf:	3b 47 58             	cmp    0x58(%edi),%eax
801019c2:	77 30                	ja     801019f4 <writei+0x104>
    ip->size = off;
    iupdate(ip);
  }
  return n;
801019c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
}
801019c7:	83 c4 2c             	add    $0x2c,%esp
801019ca:	5b                   	pop    %ebx
801019cb:	5e                   	pop    %esi
801019cc:	5f                   	pop    %edi
801019cd:	5d                   	pop    %ebp
801019ce:	c3                   	ret    
801019cf:	90                   	nop
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
801019d0:	0f bf 47 52          	movswl 0x52(%edi),%eax
801019d4:	66 83 f8 09          	cmp    $0x9,%ax
801019d8:	77 2a                	ja     80101a04 <writei+0x114>
801019da:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
801019e1:	85 c0                	test   %eax,%eax
801019e3:	74 1f                	je     80101a04 <writei+0x114>
    return devsw[ip->major].write(ip, src, n);
801019e5:	8b 55 d8             	mov    -0x28(%ebp),%edx
801019e8:	89 55 10             	mov    %edx,0x10(%ebp)
}
801019eb:	83 c4 2c             	add    $0x2c,%esp
801019ee:	5b                   	pop    %ebx
801019ef:	5e                   	pop    %esi
801019f0:	5f                   	pop    %edi
801019f1:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
801019f2:	ff e0                	jmp    *%eax
    ip->size = off;
801019f4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801019f7:	89 57 58             	mov    %edx,0x58(%edi)
    iupdate(ip);
801019fa:	89 3c 24             	mov    %edi,(%esp)
801019fd:	e8 96 fa ff ff       	call   80101498 <iupdate>
80101a02:	eb c0                	jmp    801019c4 <writei+0xd4>
      return -1;
80101a04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101a09:	83 c4 2c             	add    $0x2c,%esp
80101a0c:	5b                   	pop    %ebx
80101a0d:	5e                   	pop    %esi
80101a0e:	5f                   	pop    %edi
80101a0f:	5d                   	pop    %ebp
80101a10:	c3                   	ret    
80101a11:	8d 76 00             	lea    0x0(%esi),%esi

80101a14 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101a14:	55                   	push   %ebp
80101a15:	89 e5                	mov    %esp,%ebp
80101a17:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101a1a:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101a21:	00 
80101a22:	8b 45 0c             	mov    0xc(%ebp),%eax
80101a25:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a29:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2c:	89 04 24             	mov    %eax,(%esp)
80101a2f:	e8 54 24 00 00       	call   80103e88 <strncmp>
}
80101a34:	c9                   	leave  
80101a35:	c3                   	ret    
80101a36:	66 90                	xchg   %ax,%ax

80101a38 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101a38:	55                   	push   %ebp
80101a39:	89 e5                	mov    %esp,%ebp
80101a3b:	57                   	push   %edi
80101a3c:	56                   	push   %esi
80101a3d:	53                   	push   %ebx
80101a3e:	83 ec 2c             	sub    $0x2c,%esp
80101a41:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101a44:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101a49:	0f 85 8b 00 00 00    	jne    80101ada <dirlookup+0xa2>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101a4f:	8b 43 58             	mov    0x58(%ebx),%eax
80101a52:	85 c0                	test   %eax,%eax
80101a54:	74 6e                	je     80101ac4 <dirlookup+0x8c>
80101a56:	31 ff                	xor    %edi,%edi
80101a58:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101a5b:	eb 0b                	jmp    80101a68 <dirlookup+0x30>
80101a5d:	8d 76 00             	lea    0x0(%esi),%esi
80101a60:	83 c7 10             	add    $0x10,%edi
80101a63:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101a66:	76 5c                	jbe    80101ac4 <dirlookup+0x8c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a68:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101a6f:	00 
80101a70:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101a74:	89 74 24 04          	mov    %esi,0x4(%esp)
80101a78:	89 1c 24             	mov    %ebx,(%esp)
80101a7b:	e8 6c fd ff ff       	call   801017ec <readi>
80101a80:	83 f8 10             	cmp    $0x10,%eax
80101a83:	75 49                	jne    80101ace <dirlookup+0x96>
      panic("dirlookup read");
    if(de.inum == 0)
80101a85:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a8a:	74 d4                	je     80101a60 <dirlookup+0x28>
      continue;
    if(namecmp(name, de.name) == 0){
80101a8c:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a93:	8b 45 0c             	mov    0xc(%ebp),%eax
80101a96:	89 04 24             	mov    %eax,(%esp)
80101a99:	e8 76 ff ff ff       	call   80101a14 <namecmp>
80101a9e:	85 c0                	test   %eax,%eax
80101aa0:	75 be                	jne    80101a60 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101aa2:	8b 45 10             	mov    0x10(%ebp),%eax
80101aa5:	85 c0                	test   %eax,%eax
80101aa7:	74 05                	je     80101aae <dirlookup+0x76>
        *poff = off;
80101aa9:	8b 45 10             	mov    0x10(%ebp),%eax
80101aac:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101aae:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101ab2:	8b 03                	mov    (%ebx),%eax
80101ab4:	e8 37 f5 ff ff       	call   80100ff0 <iget>
    }
  }

  return 0;
}
80101ab9:	83 c4 2c             	add    $0x2c,%esp
80101abc:	5b                   	pop    %ebx
80101abd:	5e                   	pop    %esi
80101abe:	5f                   	pop    %edi
80101abf:	5d                   	pop    %ebp
80101ac0:	c3                   	ret    
80101ac1:	8d 76 00             	lea    0x0(%esi),%esi
  return 0;
80101ac4:	31 c0                	xor    %eax,%eax
}
80101ac6:	83 c4 2c             	add    $0x2c,%esp
80101ac9:	5b                   	pop    %ebx
80101aca:	5e                   	pop    %esi
80101acb:	5f                   	pop    %edi
80101acc:	5d                   	pop    %ebp
80101acd:	c3                   	ret    
      panic("dirlookup read");
80101ace:	c7 04 24 79 6d 10 80 	movl   $0x80106d79,(%esp)
80101ad5:	e8 36 e8 ff ff       	call   80100310 <panic>
    panic("dirlookup not DIR");
80101ada:	c7 04 24 67 6d 10 80 	movl   $0x80106d67,(%esp)
80101ae1:	e8 2a e8 ff ff       	call   80100310 <panic>
80101ae6:	66 90                	xchg   %ax,%ax

80101ae8 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ae8:	55                   	push   %ebp
80101ae9:	89 e5                	mov    %esp,%ebp
80101aeb:	57                   	push   %edi
80101aec:	56                   	push   %esi
80101aed:	53                   	push   %ebx
80101aee:	83 ec 2c             	sub    $0x2c,%esp
80101af1:	89 c3                	mov    %eax,%ebx
80101af3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101af6:	89 cf                	mov    %ecx,%edi
  struct inode *ip, *next;

  if(*path == '/')
80101af8:	80 38 2f             	cmpb   $0x2f,(%eax)
80101afb:	0f 84 eb 00 00 00    	je     80101bec <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101b01:	e8 8a 17 00 00       	call   80103290 <myproc>
80101b06:	8b 40 68             	mov    0x68(%eax),%eax
80101b09:	89 04 24             	mov    %eax,(%esp)
80101b0c:	e8 0f fa ff ff       	call   80101520 <idup>
80101b11:	89 c6                	mov    %eax,%esi
80101b13:	eb 04                	jmp    80101b19 <namex+0x31>
80101b15:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101b18:	43                   	inc    %ebx
  while(*path == '/')
80101b19:	8a 03                	mov    (%ebx),%al
80101b1b:	3c 2f                	cmp    $0x2f,%al
80101b1d:	74 f9                	je     80101b18 <namex+0x30>
  if(*path == 0)
80101b1f:	84 c0                	test   %al,%al
80101b21:	0f 84 ef 00 00 00    	je     80101c16 <namex+0x12e>
  while(*path != '/' && *path != 0)
80101b27:	8a 03                	mov    (%ebx),%al
80101b29:	89 da                	mov    %ebx,%edx
80101b2b:	3c 2f                	cmp    $0x2f,%al
80101b2d:	0f 84 93 00 00 00    	je     80101bc6 <namex+0xde>
80101b33:	84 c0                	test   %al,%al
80101b35:	75 09                	jne    80101b40 <namex+0x58>
80101b37:	e9 8a 00 00 00       	jmp    80101bc6 <namex+0xde>
80101b3c:	84 c0                	test   %al,%al
80101b3e:	74 07                	je     80101b47 <namex+0x5f>
    path++;
80101b40:	42                   	inc    %edx
  while(*path != '/' && *path != 0)
80101b41:	8a 02                	mov    (%edx),%al
80101b43:	3c 2f                	cmp    $0x2f,%al
80101b45:	75 f5                	jne    80101b3c <namex+0x54>
80101b47:	89 d1                	mov    %edx,%ecx
80101b49:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101b4b:	83 f9 0d             	cmp    $0xd,%ecx
80101b4e:	7e 78                	jle    80101bc8 <namex+0xe0>
    memmove(name, s, DIRSIZ);
80101b50:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101b57:	00 
80101b58:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101b5c:	89 3c 24             	mov    %edi,(%esp)
80101b5f:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101b62:	e8 b1 22 00 00       	call   80103e18 <memmove>
80101b67:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101b6a:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101b6c:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101b6f:	75 09                	jne    80101b7a <namex+0x92>
80101b71:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
80101b74:	43                   	inc    %ebx
  while(*path == '/')
80101b75:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101b78:	74 fa                	je     80101b74 <namex+0x8c>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101b7a:	89 34 24             	mov    %esi,(%esp)
80101b7d:	e8 ce f9 ff ff       	call   80101550 <ilock>
    if(ip->type != T_DIR){
80101b82:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101b87:	75 79                	jne    80101c02 <namex+0x11a>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101b89:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b8c:	85 d2                	test   %edx,%edx
80101b8e:	74 09                	je     80101b99 <namex+0xb1>
80101b90:	80 3b 00             	cmpb   $0x0,(%ebx)
80101b93:	0f 84 a4 00 00 00    	je     80101c3d <namex+0x155>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101b99:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101ba0:	00 
80101ba1:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101ba5:	89 34 24             	mov    %esi,(%esp)
80101ba8:	e8 8b fe ff ff       	call   80101a38 <dirlookup>
      iunlockput(ip);
80101bad:	89 34 24             	mov    %esi,(%esp)
    if((next = dirlookup(ip, name, 0)) == 0){
80101bb0:	85 c0                	test   %eax,%eax
80101bb2:	74 78                	je     80101c2c <namex+0x144>
      return 0;
    }
    iunlockput(ip);
80101bb4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101bb7:	e8 e4 fb ff ff       	call   801017a0 <iunlockput>
    ip = next;
80101bbc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101bbf:	89 c6                	mov    %eax,%esi
80101bc1:	e9 53 ff ff ff       	jmp    80101b19 <namex+0x31>
  while(*path != '/' && *path != 0)
80101bc6:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101bc8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101bcc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101bd0:	89 3c 24             	mov    %edi,(%esp)
80101bd3:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101bd6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80101bd9:	e8 3a 22 00 00       	call   80103e18 <memmove>
    name[len] = 0;
80101bde:	8b 4d dc             	mov    -0x24(%ebp),%ecx
80101be1:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101be5:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101be8:	89 d3                	mov    %edx,%ebx
80101bea:	eb 80                	jmp    80101b6c <namex+0x84>
    ip = iget(ROOTDEV, ROOTINO);
80101bec:	ba 01 00 00 00       	mov    $0x1,%edx
80101bf1:	b8 01 00 00 00       	mov    $0x1,%eax
80101bf6:	e8 f5 f3 ff ff       	call   80100ff0 <iget>
80101bfb:	89 c6                	mov    %eax,%esi
80101bfd:	e9 17 ff ff ff       	jmp    80101b19 <namex+0x31>
      iunlockput(ip);
80101c02:	89 34 24             	mov    %esi,(%esp)
80101c05:	e8 96 fb ff ff       	call   801017a0 <iunlockput>
      return 0;
80101c0a:	31 f6                	xor    %esi,%esi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101c0c:	89 f0                	mov    %esi,%eax
80101c0e:	83 c4 2c             	add    $0x2c,%esp
80101c11:	5b                   	pop    %ebx
80101c12:	5e                   	pop    %esi
80101c13:	5f                   	pop    %edi
80101c14:	5d                   	pop    %ebp
80101c15:	c3                   	ret    
  if(nameiparent){
80101c16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101c19:	85 c0                	test   %eax,%eax
80101c1b:	74 ef                	je     80101c0c <namex+0x124>
    iput(ip);
80101c1d:	89 34 24             	mov    %esi,(%esp)
80101c20:	e8 3b fa ff ff       	call   80101660 <iput>
    return 0;
80101c25:	31 f6                	xor    %esi,%esi
80101c27:	eb e3                	jmp    80101c0c <namex+0x124>
80101c29:	8d 76 00             	lea    0x0(%esi),%esi
      iunlockput(ip);
80101c2c:	e8 6f fb ff ff       	call   801017a0 <iunlockput>
      return 0;
80101c31:	31 f6                	xor    %esi,%esi
}
80101c33:	89 f0                	mov    %esi,%eax
80101c35:	83 c4 2c             	add    $0x2c,%esp
80101c38:	5b                   	pop    %ebx
80101c39:	5e                   	pop    %esi
80101c3a:	5f                   	pop    %edi
80101c3b:	5d                   	pop    %ebp
80101c3c:	c3                   	ret    
      iunlock(ip);
80101c3d:	89 34 24             	mov    %esi,(%esp)
80101c40:	e8 db f9 ff ff       	call   80101620 <iunlock>
}
80101c45:	89 f0                	mov    %esi,%eax
80101c47:	83 c4 2c             	add    $0x2c,%esp
80101c4a:	5b                   	pop    %ebx
80101c4b:	5e                   	pop    %esi
80101c4c:	5f                   	pop    %edi
80101c4d:	5d                   	pop    %ebp
80101c4e:	c3                   	ret    
80101c4f:	90                   	nop

80101c50 <dirlink>:
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	83 ec 2c             	sub    $0x2c,%esp
80101c59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101c5c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101c63:	00 
80101c64:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c67:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c6b:	89 1c 24             	mov    %ebx,(%esp)
80101c6e:	e8 c5 fd ff ff       	call   80101a38 <dirlookup>
80101c73:	85 c0                	test   %eax,%eax
80101c75:	0f 85 85 00 00 00    	jne    80101d00 <dirlink+0xb0>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101c7b:	31 ff                	xor    %edi,%edi
80101c7d:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c80:	8b 4b 58             	mov    0x58(%ebx),%ecx
80101c83:	85 c9                	test   %ecx,%ecx
80101c85:	75 0d                	jne    80101c94 <dirlink+0x44>
80101c87:	eb 2f                	jmp    80101cb8 <dirlink+0x68>
80101c89:	8d 76 00             	lea    0x0(%esi),%esi
80101c8c:	83 c7 10             	add    $0x10,%edi
80101c8f:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c92:	76 24                	jbe    80101cb8 <dirlink+0x68>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c94:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c9b:	00 
80101c9c:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ca0:	89 74 24 04          	mov    %esi,0x4(%esp)
80101ca4:	89 1c 24             	mov    %ebx,(%esp)
80101ca7:	e8 40 fb ff ff       	call   801017ec <readi>
80101cac:	83 f8 10             	cmp    $0x10,%eax
80101caf:	75 5e                	jne    80101d0f <dirlink+0xbf>
    if(de.inum == 0)
80101cb1:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101cb6:	75 d4                	jne    80101c8c <dirlink+0x3c>
  strncpy(de.name, name, DIRSIZ);
80101cb8:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101cbf:	00 
80101cc0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101cc3:	89 44 24 04          	mov    %eax,0x4(%esp)
80101cc7:	8d 45 da             	lea    -0x26(%ebp),%eax
80101cca:	89 04 24             	mov    %eax,(%esp)
80101ccd:	e8 0a 22 00 00       	call   80103edc <strncpy>
  de.inum = inum;
80101cd2:	8b 45 10             	mov    0x10(%ebp),%eax
80101cd5:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101cd9:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ce0:	00 
80101ce1:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ce5:	89 74 24 04          	mov    %esi,0x4(%esp)
80101ce9:	89 1c 24             	mov    %ebx,(%esp)
80101cec:	e8 ff fb ff ff       	call   801018f0 <writei>
80101cf1:	83 f8 10             	cmp    $0x10,%eax
80101cf4:	75 25                	jne    80101d1b <dirlink+0xcb>
  return 0;
80101cf6:	31 c0                	xor    %eax,%eax
}
80101cf8:	83 c4 2c             	add    $0x2c,%esp
80101cfb:	5b                   	pop    %ebx
80101cfc:	5e                   	pop    %esi
80101cfd:	5f                   	pop    %edi
80101cfe:	5d                   	pop    %ebp
80101cff:	c3                   	ret    
    iput(ip);
80101d00:	89 04 24             	mov    %eax,(%esp)
80101d03:	e8 58 f9 ff ff       	call   80101660 <iput>
    return -1;
80101d08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d0d:	eb e9                	jmp    80101cf8 <dirlink+0xa8>
      panic("dirlink read");
80101d0f:	c7 04 24 88 6d 10 80 	movl   $0x80106d88,(%esp)
80101d16:	e8 f5 e5 ff ff       	call   80100310 <panic>
    panic("dirlink");
80101d1b:	c7 04 24 72 73 10 80 	movl   $0x80107372,(%esp)
80101d22:	e8 e9 e5 ff ff       	call   80100310 <panic>
80101d27:	90                   	nop

80101d28 <namei>:

struct inode*
namei(char *path)
{
80101d28:	55                   	push   %ebp
80101d29:	89 e5                	mov    %esp,%ebp
80101d2b:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101d2e:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101d31:	31 d2                	xor    %edx,%edx
80101d33:	8b 45 08             	mov    0x8(%ebp),%eax
80101d36:	e8 ad fd ff ff       	call   80101ae8 <namex>
}
80101d3b:	c9                   	leave  
80101d3c:	c3                   	ret    
80101d3d:	8d 76 00             	lea    0x0(%esi),%esi

80101d40 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101d43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101d46:	ba 01 00 00 00       	mov    $0x1,%edx
80101d4b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101d4e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101d4f:	e9 94 fd ff ff       	jmp    80101ae8 <namex>

80101d54 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101d54:	55                   	push   %ebp
80101d55:	89 e5                	mov    %esp,%ebp
80101d57:	56                   	push   %esi
80101d58:	53                   	push   %ebx
80101d59:	83 ec 10             	sub    $0x10,%esp
80101d5c:	89 c6                	mov    %eax,%esi
  if(b == 0)
80101d5e:	85 c0                	test   %eax,%eax
80101d60:	0f 84 8a 00 00 00    	je     80101df0 <idestart+0x9c>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101d66:	8b 48 08             	mov    0x8(%eax),%ecx
80101d69:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101d6f:	77 73                	ja     80101de4 <idestart+0x90>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101d71:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d76:	66 90                	xchg   %ax,%ax
80101d78:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101d79:	83 e0 c0             	and    $0xffffffc0,%eax
80101d7c:	3c 40                	cmp    $0x40,%al
80101d7e:	75 f8                	jne    80101d78 <idestart+0x24>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d80:	31 db                	xor    %ebx,%ebx
80101d82:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101d87:	88 d8                	mov    %bl,%al
80101d89:	ee                   	out    %al,(%dx)
80101d8a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101d8f:	b0 01                	mov    $0x1,%al
80101d91:	ee                   	out    %al,(%dx)
    sleep(b, &idelock);
  }


  release(&idelock);
}
80101d92:	0f b6 c1             	movzbl %cl,%eax
80101d95:	b2 f3                	mov    $0xf3,%dl
80101d97:	ee                   	out    %al,(%dx)
  outb(0x1f4, (sector >> 8) & 0xff);
80101d98:	89 c8                	mov    %ecx,%eax
80101d9a:	c1 f8 08             	sar    $0x8,%eax
80101d9d:	b2 f4                	mov    $0xf4,%dl
80101d9f:	ee                   	out    %al,(%dx)
80101da0:	b2 f5                	mov    $0xf5,%dl
80101da2:	88 d8                	mov    %bl,%al
80101da4:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101da5:	8b 46 04             	mov    0x4(%esi),%eax
80101da8:	83 e0 01             	and    $0x1,%eax
80101dab:	c1 e0 04             	shl    $0x4,%eax
80101dae:	83 c8 e0             	or     $0xffffffe0,%eax
80101db1:	b2 f6                	mov    $0xf6,%dl
80101db3:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101db4:	f6 06 04             	testb  $0x4,(%esi)
80101db7:	75 0f                	jne    80101dc8 <idestart+0x74>
80101db9:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101dbe:	b0 20                	mov    $0x20,%al
80101dc0:	ee                   	out    %al,(%dx)
}
80101dc1:	83 c4 10             	add    $0x10,%esp
80101dc4:	5b                   	pop    %ebx
80101dc5:	5e                   	pop    %esi
80101dc6:	5d                   	pop    %ebp
80101dc7:	c3                   	ret    
80101dc8:	b2 f7                	mov    $0xf7,%dl
80101dca:	b0 30                	mov    $0x30,%al
80101dcc:	ee                   	out    %al,(%dx)
    outsl(0x1f0, b->data, BSIZE/4);
80101dcd:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101dd0:	b9 80 00 00 00       	mov    $0x80,%ecx
80101dd5:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101dda:	fc                   	cld    
80101ddb:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80101ddd:	83 c4 10             	add    $0x10,%esp
80101de0:	5b                   	pop    %ebx
80101de1:	5e                   	pop    %esi
80101de2:	5d                   	pop    %ebp
80101de3:	c3                   	ret    
    panic("incorrect blockno");
80101de4:	c7 04 24 f4 6d 10 80 	movl   $0x80106df4,(%esp)
80101deb:	e8 20 e5 ff ff       	call   80100310 <panic>
    panic("idestart");
80101df0:	c7 04 24 eb 6d 10 80 	movl   $0x80106deb,(%esp)
80101df7:	e8 14 e5 ff ff       	call   80100310 <panic>

80101dfc <ideinit>:
{
80101dfc:	55                   	push   %ebp
80101dfd:	89 e5                	mov    %esp,%ebp
80101dff:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
80101e02:	c7 44 24 04 06 6e 10 	movl   $0x80106e06,0x4(%esp)
80101e09:	80 
80101e0a:	c7 04 24 60 a5 10 80 	movl   $0x8010a560,(%esp)
80101e11:	e8 a2 1d 00 00       	call   80103bb8 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101e16:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101e1b:	48                   	dec    %eax
80101e1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e20:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80101e27:	e8 50 02 00 00       	call   8010207c <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e2c:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101e31:	8d 76 00             	lea    0x0(%esi),%esi
80101e34:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101e35:	83 e0 c0             	and    $0xffffffc0,%eax
80101e38:	3c 40                	cmp    $0x40,%al
80101e3a:	75 f8                	jne    80101e34 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101e3c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101e41:	b0 f0                	mov    $0xf0,%al
80101e43:	ee                   	out    %al,(%dx)
80101e44:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101e49:	b2 f7                	mov    $0xf7,%dl
80101e4b:	eb 06                	jmp    80101e53 <ideinit+0x57>
80101e4d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i=0; i<1000; i++){
80101e50:	49                   	dec    %ecx
80101e51:	74 0f                	je     80101e62 <ideinit+0x66>
80101e53:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101e54:	84 c0                	test   %al,%al
80101e56:	74 f8                	je     80101e50 <ideinit+0x54>
      havedisk1 = 1;
80101e58:	c7 05 94 a5 10 80 01 	movl   $0x1,0x8010a594
80101e5f:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101e62:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101e67:	b0 e0                	mov    $0xe0,%al
80101e69:	ee                   	out    %al,(%dx)
}
80101e6a:	c9                   	leave  
80101e6b:	c3                   	ret    

80101e6c <ideintr>:
{
80101e6c:	55                   	push   %ebp
80101e6d:	89 e5                	mov    %esp,%ebp
80101e6f:	57                   	push   %edi
80101e70:	56                   	push   %esi
80101e71:	53                   	push   %ebx
80101e72:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&idelock);
80101e75:	c7 04 24 60 a5 10 80 	movl   $0x8010a560,(%esp)
80101e7c:	e8 ff 1d 00 00       	call   80103c80 <acquire>
  if((b = idequeue) == 0){
80101e81:	8b 1d 98 a5 10 80    	mov    0x8010a598,%ebx
80101e87:	85 db                	test   %ebx,%ebx
80101e89:	74 30                	je     80101ebb <ideintr+0x4f>
  idequeue = b->qnext;
80101e8b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e8e:	a3 98 a5 10 80       	mov    %eax,0x8010a598
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e93:	8b 33                	mov    (%ebx),%esi
80101e95:	f7 c6 04 00 00 00    	test   $0x4,%esi
80101e9b:	74 33                	je     80101ed0 <ideintr+0x64>
  b->flags &= ~B_DIRTY;
80101e9d:	83 e6 fb             	and    $0xfffffffb,%esi
80101ea0:	83 ce 02             	or     $0x2,%esi
80101ea3:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
80101ea5:	89 1c 24             	mov    %ebx,(%esp)
80101ea8:	e8 8f 1a 00 00       	call   8010393c <wakeup>
  if(idequeue != 0)
80101ead:	a1 98 a5 10 80       	mov    0x8010a598,%eax
80101eb2:	85 c0                	test   %eax,%eax
80101eb4:	74 05                	je     80101ebb <ideintr+0x4f>
    idestart(idequeue);
80101eb6:	e8 99 fe ff ff       	call   80101d54 <idestart>
    release(&idelock);
80101ebb:	c7 04 24 60 a5 10 80 	movl   $0x8010a560,(%esp)
80101ec2:	e8 75 1e 00 00       	call   80103d3c <release>
}
80101ec7:	83 c4 1c             	add    $0x1c,%esp
80101eca:	5b                   	pop    %ebx
80101ecb:	5e                   	pop    %esi
80101ecc:	5f                   	pop    %edi
80101ecd:	5d                   	pop    %ebp
80101ece:	c3                   	ret    
80101ecf:	90                   	nop
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ed0:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101ed5:	8d 76 00             	lea    0x0(%esi),%esi
80101ed8:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101ed9:	88 c1                	mov    %al,%cl
80101edb:	83 e1 c0             	and    $0xffffffc0,%ecx
80101ede:	80 f9 40             	cmp    $0x40,%cl
80101ee1:	75 f5                	jne    80101ed8 <ideintr+0x6c>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101ee3:	a8 21                	test   $0x21,%al
80101ee5:	75 b6                	jne    80101e9d <ideintr+0x31>
    insl(0x1f0, b->data, BSIZE/4);
80101ee7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101eea:	b9 80 00 00 00       	mov    $0x80,%ecx
80101eef:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101ef4:	fc                   	cld    
80101ef5:	f3 6d                	rep insl (%dx),%es:(%edi)
80101ef7:	8b 33                	mov    (%ebx),%esi
80101ef9:	eb a2                	jmp    80101e9d <ideintr+0x31>
80101efb:	90                   	nop

80101efc <iderw>:
{
80101efc:	55                   	push   %ebp
80101efd:	89 e5                	mov    %esp,%ebp
80101eff:	53                   	push   %ebx
80101f00:	83 ec 14             	sub    $0x14,%esp
80101f03:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
80101f06:	8d 43 0c             	lea    0xc(%ebx),%eax
80101f09:	89 04 24             	mov    %eax,(%esp)
80101f0c:	e8 7b 1c 00 00       	call   80103b8c <holdingsleep>
80101f11:	85 c0                	test   %eax,%eax
80101f13:	0f 84 9e 00 00 00    	je     80101fb7 <iderw+0xbb>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101f19:	8b 03                	mov    (%ebx),%eax
80101f1b:	83 e0 06             	and    $0x6,%eax
80101f1e:	83 f8 02             	cmp    $0x2,%eax
80101f21:	0f 84 a8 00 00 00    	je     80101fcf <iderw+0xd3>
  if(b->dev != 0 && !havedisk1)
80101f27:	8b 53 04             	mov    0x4(%ebx),%edx
80101f2a:	85 d2                	test   %edx,%edx
80101f2c:	74 0d                	je     80101f3b <iderw+0x3f>
80101f2e:	a1 94 a5 10 80       	mov    0x8010a594,%eax
80101f33:	85 c0                	test   %eax,%eax
80101f35:	0f 84 88 00 00 00    	je     80101fc3 <iderw+0xc7>
  acquire(&idelock);  //DOC:acquire-lock
80101f3b:	c7 04 24 60 a5 10 80 	movl   $0x8010a560,(%esp)
80101f42:	e8 39 1d 00 00       	call   80103c80 <acquire>
  b->qnext = 0;
80101f47:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f4e:	a1 98 a5 10 80       	mov    0x8010a598,%eax
80101f53:	85 c0                	test   %eax,%eax
80101f55:	75 07                	jne    80101f5e <iderw+0x62>
80101f57:	eb 4e                	jmp    80101fa7 <iderw+0xab>
80101f59:	8d 76 00             	lea    0x0(%esi),%esi
80101f5c:	89 d0                	mov    %edx,%eax
80101f5e:	8b 50 58             	mov    0x58(%eax),%edx
80101f61:	85 d2                	test   %edx,%edx
80101f63:	75 f7                	jne    80101f5c <iderw+0x60>
80101f65:	83 c0 58             	add    $0x58,%eax
  *pp = b;
80101f68:	89 18                	mov    %ebx,(%eax)
  if(idequeue == b)
80101f6a:	39 1d 98 a5 10 80    	cmp    %ebx,0x8010a598
80101f70:	74 3c                	je     80101fae <iderw+0xb2>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f72:	8b 03                	mov    (%ebx),%eax
80101f74:	83 e0 06             	and    $0x6,%eax
80101f77:	83 f8 02             	cmp    $0x2,%eax
80101f7a:	74 1a                	je     80101f96 <iderw+0x9a>
    sleep(b, &idelock);
80101f7c:	c7 44 24 04 60 a5 10 	movl   $0x8010a560,0x4(%esp)
80101f83:	80 
80101f84:	89 1c 24             	mov    %ebx,(%esp)
80101f87:	e8 30 18 00 00       	call   801037bc <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f8c:	8b 13                	mov    (%ebx),%edx
80101f8e:	83 e2 06             	and    $0x6,%edx
80101f91:	83 fa 02             	cmp    $0x2,%edx
80101f94:	75 e6                	jne    80101f7c <iderw+0x80>
  release(&idelock);
80101f96:	c7 45 08 60 a5 10 80 	movl   $0x8010a560,0x8(%ebp)
}
80101f9d:	83 c4 14             	add    $0x14,%esp
80101fa0:	5b                   	pop    %ebx
80101fa1:	5d                   	pop    %ebp
  release(&idelock);
80101fa2:	e9 95 1d 00 00       	jmp    80103d3c <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101fa7:	b8 98 a5 10 80       	mov    $0x8010a598,%eax
80101fac:	eb ba                	jmp    80101f68 <iderw+0x6c>
    idestart(b);
80101fae:	89 d8                	mov    %ebx,%eax
80101fb0:	e8 9f fd ff ff       	call   80101d54 <idestart>
80101fb5:	eb bb                	jmp    80101f72 <iderw+0x76>
    panic("iderw: buf not locked");
80101fb7:	c7 04 24 0a 6e 10 80 	movl   $0x80106e0a,(%esp)
80101fbe:	e8 4d e3 ff ff       	call   80100310 <panic>
    panic("iderw: ide disk 1 not present");
80101fc3:	c7 04 24 35 6e 10 80 	movl   $0x80106e35,(%esp)
80101fca:	e8 41 e3 ff ff       	call   80100310 <panic>
    panic("iderw: nothing to do");
80101fcf:	c7 04 24 20 6e 10 80 	movl   $0x80106e20,(%esp)
80101fd6:	e8 35 e3 ff ff       	call   80100310 <panic>
80101fdb:	90                   	nop

80101fdc <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80101fdc:	55                   	push   %ebp
80101fdd:	89 e5                	mov    %esp,%ebp
80101fdf:	56                   	push   %esi
80101fe0:	53                   	push   %ebx
80101fe1:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101fe4:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80101feb:	00 c0 fe 
  ioapic->reg = reg;
80101fee:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80101ff5:	00 00 00 
  return ioapic->data;
80101ff8:	8b 35 10 00 c0 fe    	mov    0xfec00010,%esi
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101ffe:	c1 ee 10             	shr    $0x10,%esi
80102001:	81 e6 ff 00 00 00    	and    $0xff,%esi
  ioapic->reg = reg;
80102007:	c7 05 00 00 c0 fe 00 	movl   $0x0,0xfec00000
8010200e:	00 00 00 
  return ioapic->data;
80102011:	bb 00 00 c0 fe       	mov    $0xfec00000,%ebx
80102016:	a1 10 00 c0 fe       	mov    0xfec00010,%eax
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010201b:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  id = ioapicread(REG_ID) >> 24;
80102022:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102025:	39 c2                	cmp    %eax,%edx
80102027:	74 12                	je     8010203b <ioapicinit+0x5f>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102029:	c7 04 24 54 6e 10 80 	movl   $0x80106e54,(%esp)
80102030:	e8 7f e5 ff ff       	call   801005b4 <cprintf>
80102035:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
{
8010203b:	ba 10 00 00 00       	mov    $0x10,%edx
80102040:	31 c0                	xor    %eax,%eax
80102042:	66 90                	xchg   %ax,%ax
ioapicinit(void)
80102044:	8d 48 20             	lea    0x20(%eax),%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102047:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  ioapic->reg = reg;
8010204d:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010204f:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102055:	89 4b 10             	mov    %ecx,0x10(%ebx)
ioapicinit(void)
80102058:	8d 4a 01             	lea    0x1(%edx),%ecx
  ioapic->reg = reg;
8010205b:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
8010205d:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102063:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
  for(i = 0; i <= maxintr; i++){
8010206a:	40                   	inc    %eax
8010206b:	83 c2 02             	add    $0x2,%edx
8010206e:	39 c6                	cmp    %eax,%esi
80102070:	7d d2                	jge    80102044 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102072:	83 c4 10             	add    $0x10,%esp
80102075:	5b                   	pop    %ebx
80102076:	5e                   	pop    %esi
80102077:	5d                   	pop    %ebp
80102078:	c3                   	ret    
80102079:	8d 76 00             	lea    0x0(%esi),%esi

8010207c <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
8010207c:	55                   	push   %ebp
8010207d:	89 e5                	mov    %esp,%ebp
8010207f:	53                   	push   %ebx
80102080:	8b 55 08             	mov    0x8(%ebp),%edx
80102083:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102086:	8d 5a 20             	lea    0x20(%edx),%ebx
80102089:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
  ioapic->reg = reg;
8010208d:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102093:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
80102095:	8b 15 34 26 11 80    	mov    0x80112634,%edx
8010209b:	89 5a 10             	mov    %ebx,0x10(%edx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010209e:	c1 e0 18             	shl    $0x18,%eax
801020a1:	41                   	inc    %ecx
  ioapic->reg = reg;
801020a2:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801020a4:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801020aa:	89 42 10             	mov    %eax,0x10(%edx)
}
801020ad:	5b                   	pop    %ebx
801020ae:	5d                   	pop    %ebp
801020af:	c3                   	ret    

801020b0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	53                   	push   %ebx
801020b4:	83 ec 14             	sub    $0x14,%esp
801020b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801020ba:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801020c0:	75 78                	jne    8010213a <kfree+0x8a>
801020c2:	81 fb d8 5f 11 80    	cmp    $0x80115fd8,%ebx
801020c8:	72 70                	jb     8010213a <kfree+0x8a>
801020ca:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801020d0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801020d5:	77 63                	ja     8010213a <kfree+0x8a>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801020d7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801020de:	00 
801020df:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801020e6:	00 
801020e7:	89 1c 24             	mov    %ebx,(%esp)
801020ea:	e8 95 1c 00 00       	call   80103d84 <memset>

  if(kmem.use_lock)
801020ef:	8b 15 74 26 11 80    	mov    0x80112674,%edx
801020f5:	85 d2                	test   %edx,%edx
801020f7:	75 33                	jne    8010212c <kfree+0x7c>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801020f9:	a1 78 26 11 80       	mov    0x80112678,%eax
801020fe:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80102100:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102106:	a1 74 26 11 80       	mov    0x80112674,%eax
8010210b:	85 c0                	test   %eax,%eax
8010210d:	75 09                	jne    80102118 <kfree+0x68>
    release(&kmem.lock);
}
8010210f:	83 c4 14             	add    $0x14,%esp
80102112:	5b                   	pop    %ebx
80102113:	5d                   	pop    %ebp
80102114:	c3                   	ret    
80102115:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102118:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010211f:	83 c4 14             	add    $0x14,%esp
80102122:	5b                   	pop    %ebx
80102123:	5d                   	pop    %ebp
    release(&kmem.lock);
80102124:	e9 13 1c 00 00       	jmp    80103d3c <release>
80102129:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
8010212c:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102133:	e8 48 1b 00 00       	call   80103c80 <acquire>
80102138:	eb bf                	jmp    801020f9 <kfree+0x49>
    panic("kfree");
8010213a:	c7 04 24 86 6e 10 80 	movl   $0x80106e86,(%esp)
80102141:	e8 ca e1 ff ff       	call   80100310 <panic>
80102146:	66 90                	xchg   %ax,%ax

80102148 <freerange>:
{
80102148:	55                   	push   %ebp
80102149:	89 e5                	mov    %esp,%ebp
8010214b:	56                   	push   %esi
8010214c:	53                   	push   %ebx
8010214d:	83 ec 10             	sub    $0x10,%esp
80102150:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
80102153:	8b 45 08             	mov    0x8(%ebp),%eax
80102156:	05 ff 0f 00 00       	add    $0xfff,%eax
8010215b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102160:	8d 98 00 10 00 00    	lea    0x1000(%eax),%ebx
80102166:	39 de                	cmp    %ebx,%esi
80102168:	72 16                	jb     80102180 <freerange+0x38>
8010216a:	66 90                	xchg   %ax,%ax
    kfree(p);
8010216c:	89 04 24             	mov    %eax,(%esp)
8010216f:	e8 3c ff ff ff       	call   801020b0 <kfree>
80102174:	89 d8                	mov    %ebx,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102176:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010217c:	39 f3                	cmp    %esi,%ebx
8010217e:	76 ec                	jbe    8010216c <freerange+0x24>
}
80102180:	83 c4 10             	add    $0x10,%esp
80102183:	5b                   	pop    %ebx
80102184:	5e                   	pop    %esi
80102185:	5d                   	pop    %ebp
80102186:	c3                   	ret    
80102187:	90                   	nop

80102188 <kinit2>:
{
80102188:	55                   	push   %ebp
80102189:	89 e5                	mov    %esp,%ebp
8010218b:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
8010218e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102191:	89 44 24 04          	mov    %eax,0x4(%esp)
80102195:	8b 45 08             	mov    0x8(%ebp),%eax
80102198:	89 04 24             	mov    %eax,(%esp)
8010219b:	e8 a8 ff ff ff       	call   80102148 <freerange>
  kmem.use_lock = 1;
801021a0:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801021a7:	00 00 00 
}
801021aa:	c9                   	leave  
801021ab:	c3                   	ret    

801021ac <kinit1>:
{
801021ac:	55                   	push   %ebp
801021ad:	89 e5                	mov    %esp,%ebp
801021af:	56                   	push   %esi
801021b0:	53                   	push   %ebx
801021b1:	83 ec 10             	sub    $0x10,%esp
801021b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
801021b7:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801021ba:	c7 44 24 04 8c 6e 10 	movl   $0x80106e8c,0x4(%esp)
801021c1:	80 
801021c2:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801021c9:	e8 ea 19 00 00       	call   80103bb8 <initlock>
  kmem.use_lock = 0;
801021ce:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
801021d5:	00 00 00 
  freerange(vstart, vend);
801021d8:	89 75 0c             	mov    %esi,0xc(%ebp)
801021db:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801021de:	83 c4 10             	add    $0x10,%esp
801021e1:	5b                   	pop    %ebx
801021e2:	5e                   	pop    %esi
801021e3:	5d                   	pop    %ebp
  freerange(vstart, vend);
801021e4:	e9 5f ff ff ff       	jmp    80102148 <freerange>
801021e9:	8d 76 00             	lea    0x0(%esi),%esi

801021ec <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801021ec:	55                   	push   %ebp
801021ed:	89 e5                	mov    %esp,%ebp
801021ef:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
801021f2:	8b 0d 74 26 11 80    	mov    0x80112674,%ecx
801021f8:	85 c9                	test   %ecx,%ecx
801021fa:	75 30                	jne    8010222c <kalloc+0x40>
801021fc:	31 d2                	xor    %edx,%edx
    acquire(&kmem.lock);
  r = kmem.freelist;
801021fe:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
80102203:	85 c0                	test   %eax,%eax
80102205:	74 08                	je     8010220f <kalloc+0x23>
    kmem.freelist = r->next;
80102207:	8b 08                	mov    (%eax),%ecx
80102209:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
8010220f:	85 d2                	test   %edx,%edx
80102211:	75 05                	jne    80102218 <kalloc+0x2c>
    release(&kmem.lock);
  return (char*)r;
}
80102213:	c9                   	leave  
80102214:	c3                   	ret    
80102215:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102218:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010221f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102222:	e8 15 1b 00 00       	call   80103d3c <release>
80102227:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010222a:	c9                   	leave  
8010222b:	c3                   	ret    
    acquire(&kmem.lock);
8010222c:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102233:	e8 48 1a 00 00       	call   80103c80 <acquire>
80102238:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010223e:	eb be                	jmp    801021fe <kalloc+0x12>

80102240 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102240:	ba 64 00 00 00       	mov    $0x64,%edx
80102245:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102246:	a8 01                	test   $0x1,%al
80102248:	0f 84 ae 00 00 00    	je     801022fc <kbdgetc+0xbc>
8010224e:	b2 60                	mov    $0x60,%dl
80102250:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102251:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102254:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010225a:	0f 84 80 00 00 00    	je     801022e0 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102260:	84 c0                	test   %al,%al
80102262:	79 28                	jns    8010228c <kbdgetc+0x4c>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102264:	8b 15 9c a5 10 80    	mov    0x8010a59c,%edx
8010226a:	f6 c2 40             	test   $0x40,%dl
8010226d:	75 05                	jne    80102274 <kbdgetc+0x34>
8010226f:	89 c1                	mov    %eax,%ecx
80102271:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102274:	8a 81 a0 6e 10 80    	mov    -0x7fef9160(%ecx),%al
8010227a:	83 c8 40             	or     $0x40,%eax
8010227d:	0f b6 c0             	movzbl %al,%eax
80102280:	f7 d0                	not    %eax
80102282:	21 d0                	and    %edx,%eax
80102284:	a3 9c a5 10 80       	mov    %eax,0x8010a59c
    return 0;
80102289:	31 c0                	xor    %eax,%eax
8010228b:	c3                   	ret    
{
8010228c:	55                   	push   %ebp
8010228d:	89 e5                	mov    %esp,%ebp
8010228f:	53                   	push   %ebx
  } else if(shift & E0ESC){
80102290:	8b 1d 9c a5 10 80    	mov    0x8010a59c,%ebx
80102296:	f6 c3 40             	test   $0x40,%bl
80102299:	74 09                	je     801022a4 <kbdgetc+0x64>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010229b:	83 c8 80             	or     $0xffffff80,%eax
8010229e:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
801022a1:	83 e3 bf             	and    $0xffffffbf,%ebx
  }

  shift |= shiftcode[data];
801022a4:	0f b6 91 a0 6e 10 80 	movzbl -0x7fef9160(%ecx),%edx
801022ab:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801022ad:	0f b6 81 a0 6f 10 80 	movzbl -0x7fef9060(%ecx),%eax
801022b4:	31 c2                	xor    %eax,%edx
801022b6:	89 15 9c a5 10 80    	mov    %edx,0x8010a59c
  c = charcode[shift & (CTL | SHIFT)][data];
801022bc:	89 d0                	mov    %edx,%eax
801022be:	83 e0 03             	and    $0x3,%eax
801022c1:	8b 04 85 a0 70 10 80 	mov    -0x7fef8f60(,%eax,4),%eax
801022c8:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801022cc:	83 e2 08             	and    $0x8,%edx
801022cf:	74 0b                	je     801022dc <kbdgetc+0x9c>
    if('a' <= c && c <= 'z')
801022d1:	8d 50 9f             	lea    -0x61(%eax),%edx
801022d4:	83 fa 19             	cmp    $0x19,%edx
801022d7:	77 13                	ja     801022ec <kbdgetc+0xac>
      c += 'A' - 'a';
801022d9:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801022dc:	5b                   	pop    %ebx
801022dd:	5d                   	pop    %ebp
801022de:	c3                   	ret    
801022df:	90                   	nop
    shift |= E0ESC;
801022e0:	83 0d 9c a5 10 80 40 	orl    $0x40,0x8010a59c
    return 0;
801022e7:	31 c0                	xor    %eax,%eax
801022e9:	c3                   	ret    
801022ea:	66 90                	xchg   %ax,%ax
    else if('A' <= c && c <= 'Z')
801022ec:	8d 50 bf             	lea    -0x41(%eax),%edx
801022ef:	83 fa 19             	cmp    $0x19,%edx
801022f2:	77 e8                	ja     801022dc <kbdgetc+0x9c>
      c += 'a' - 'A';
801022f4:	83 c0 20             	add    $0x20,%eax
  return c;
801022f7:	eb e3                	jmp    801022dc <kbdgetc+0x9c>
801022f9:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801022fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102301:	c3                   	ret    
80102302:	66 90                	xchg   %ax,%ax

80102304 <kbdintr>:

void
kbdintr(void)
{
80102304:	55                   	push   %ebp
80102305:	89 e5                	mov    %esp,%ebp
80102307:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
8010230a:	c7 04 24 40 22 10 80 	movl   $0x80102240,(%esp)
80102311:	e8 ea e3 ff ff       	call   80100700 <consoleintr>
}
80102316:	c9                   	leave  
80102317:	c3                   	ret    

80102318 <fill_rtcdate>:

  return inb(CMOS_RETURN);
}

static void fill_rtcdate(struct rtcdate *r)
{
80102318:	55                   	push   %ebp
80102319:	89 e5                	mov    %esp,%ebp
8010231b:	53                   	push   %ebx
8010231c:	89 c1                	mov    %eax,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010231e:	ba 70 00 00 00       	mov    $0x70,%edx
80102323:	31 c0                	xor    %eax,%eax
80102325:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102326:	bb 71 00 00 00       	mov    $0x71,%ebx
8010232b:	89 da                	mov    %ebx,%edx
8010232d:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
8010232e:	0f b6 c0             	movzbl %al,%eax
80102331:	89 01                	mov    %eax,(%ecx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102333:	b2 70                	mov    $0x70,%dl
80102335:	b0 02                	mov    $0x2,%al
80102337:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102338:	89 da                	mov    %ebx,%edx
8010233a:	ec                   	in     (%dx),%al
8010233b:	0f b6 c0             	movzbl %al,%eax
8010233e:	89 41 04             	mov    %eax,0x4(%ecx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102341:	b2 70                	mov    $0x70,%dl
80102343:	b0 04                	mov    $0x4,%al
80102345:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102346:	89 da                	mov    %ebx,%edx
80102348:	ec                   	in     (%dx),%al
80102349:	0f b6 c0             	movzbl %al,%eax
8010234c:	89 41 08             	mov    %eax,0x8(%ecx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010234f:	b2 70                	mov    $0x70,%dl
80102351:	b0 07                	mov    $0x7,%al
80102353:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102354:	89 da                	mov    %ebx,%edx
80102356:	ec                   	in     (%dx),%al
80102357:	0f b6 c0             	movzbl %al,%eax
8010235a:	89 41 0c             	mov    %eax,0xc(%ecx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010235d:	b2 70                	mov    $0x70,%dl
8010235f:	b0 08                	mov    $0x8,%al
80102361:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102362:	89 da                	mov    %ebx,%edx
80102364:	ec                   	in     (%dx),%al
80102365:	0f b6 c0             	movzbl %al,%eax
80102368:	89 41 10             	mov    %eax,0x10(%ecx)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010236b:	b2 70                	mov    $0x70,%dl
8010236d:	b0 09                	mov    $0x9,%al
8010236f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102370:	89 da                	mov    %ebx,%edx
80102372:	ec                   	in     (%dx),%al
80102373:	0f b6 d8             	movzbl %al,%ebx
80102376:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102379:	5b                   	pop    %ebx
8010237a:	5d                   	pop    %ebp
8010237b:	c3                   	ret    

8010237c <lapicinit>:
{
8010237c:	55                   	push   %ebp
8010237d:	89 e5                	mov    %esp,%ebp
  if(!lapic)
8010237f:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102384:	85 c0                	test   %eax,%eax
80102386:	0f 84 c0 00 00 00    	je     8010244c <lapicinit+0xd0>
  lapic[index] = value;
8010238c:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102393:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102396:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102399:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801023a0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801023a3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801023a6:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801023ad:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801023b0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801023b3:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801023ba:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801023bd:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801023c0:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801023c7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801023ca:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801023cd:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801023d4:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801023d7:	8b 50 20             	mov    0x20(%eax),%edx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801023da:	8b 50 30             	mov    0x30(%eax),%edx
801023dd:	c1 ea 10             	shr    $0x10,%edx
801023e0:	80 fa 03             	cmp    $0x3,%dl
801023e3:	77 6b                	ja     80102450 <lapicinit+0xd4>
  lapic[index] = value;
801023e5:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801023ec:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801023ef:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801023f2:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801023f9:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801023fc:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801023ff:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
80102406:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102409:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010240c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102413:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102416:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102419:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102420:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102423:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102426:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
8010242d:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102430:	8b 50 20             	mov    0x20(%eax),%edx
80102433:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
80102434:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010243a:	80 e6 10             	and    $0x10,%dh
8010243d:	75 f5                	jne    80102434 <lapicinit+0xb8>
  lapic[index] = value;
8010243f:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102446:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102449:	8b 40 20             	mov    0x20(%eax),%eax
}
8010244c:	5d                   	pop    %ebp
8010244d:	c3                   	ret    
8010244e:	66 90                	xchg   %ax,%ax
  lapic[index] = value;
80102450:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102457:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010245a:	8b 50 20             	mov    0x20(%eax),%edx
8010245d:	eb 86                	jmp    801023e5 <lapicinit+0x69>
8010245f:	90                   	nop

80102460 <lapicid>:
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102463:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102468:	85 c0                	test   %eax,%eax
8010246a:	74 08                	je     80102474 <lapicid+0x14>
  return lapic[ID] >> 24;
8010246c:	8b 40 20             	mov    0x20(%eax),%eax
8010246f:	c1 e8 18             	shr    $0x18,%eax
}
80102472:	5d                   	pop    %ebp
80102473:	c3                   	ret    
    return 0;
80102474:	31 c0                	xor    %eax,%eax
}
80102476:	5d                   	pop    %ebp
80102477:	c3                   	ret    

80102478 <lapiceoi>:
{
80102478:	55                   	push   %ebp
80102479:	89 e5                	mov    %esp,%ebp
  if(lapic)
8010247b:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102480:	85 c0                	test   %eax,%eax
80102482:	74 0d                	je     80102491 <lapiceoi+0x19>
  lapic[index] = value;
80102484:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
8010248b:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010248e:	8b 40 20             	mov    0x20(%eax),%eax
}
80102491:	5d                   	pop    %ebp
80102492:	c3                   	ret    
80102493:	90                   	nop

80102494 <microdelay>:
{
80102494:	55                   	push   %ebp
80102495:	89 e5                	mov    %esp,%ebp
}
80102497:	5d                   	pop    %ebp
80102498:	c3                   	ret    
80102499:	8d 76 00             	lea    0x0(%esi),%esi

8010249c <lapicstartap>:
{
8010249c:	55                   	push   %ebp
8010249d:	89 e5                	mov    %esp,%ebp
8010249f:	53                   	push   %ebx
801024a0:	8a 4d 08             	mov    0x8(%ebp),%cl
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024a3:	ba 70 00 00 00       	mov    $0x70,%edx
801024a8:	b0 0f                	mov    $0xf,%al
801024aa:	ee                   	out    %al,(%dx)
801024ab:	b2 71                	mov    $0x71,%dl
801024ad:	b0 0a                	mov    $0xa,%al
801024af:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801024b0:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
801024b7:	00 00 
  wrv[1] = addr >> 4;
801024b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801024bc:	c1 e8 04             	shr    $0x4,%eax
801024bf:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
801024c5:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(ICRHI, apicid<<24);
801024ca:	c1 e1 18             	shl    $0x18,%ecx
  lapic[index] = value;
801024cd:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801024d3:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801024d6:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
801024dd:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
801024e0:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801024e3:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801024ea:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801024ed:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801024f0:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801024f6:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
801024f9:	8b 55 0c             	mov    0xc(%ebp),%edx
801024fc:	c1 ea 0c             	shr    $0xc,%edx
801024ff:	80 ce 06             	or     $0x6,%dh
  lapic[index] = value;
80102502:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102508:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010250b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102511:	8b 48 20             	mov    0x20(%eax),%ecx
  lapic[index] = value;
80102514:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010251a:	8b 40 20             	mov    0x20(%eax),%eax
}
8010251d:	5b                   	pop    %ebx
8010251e:	5d                   	pop    %ebp
8010251f:	c3                   	ret    

80102520 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80102520:	55                   	push   %ebp
80102521:	89 e5                	mov    %esp,%ebp
80102523:	57                   	push   %edi
80102524:	56                   	push   %esi
80102525:	53                   	push   %ebx
80102526:	83 ec 5c             	sub    $0x5c,%esp
80102529:	ba 70 00 00 00       	mov    $0x70,%edx
8010252e:	b0 0b                	mov    $0xb,%al
80102530:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102531:	b2 71                	mov    $0x71,%dl
80102533:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102534:	83 e0 04             	and    $0x4,%eax
80102537:	88 45 b7             	mov    %al,-0x49(%ebp)
8010253a:	8d 75 b8             	lea    -0x48(%ebp),%esi
8010253d:	8d 7d d0             	lea    -0x30(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102540:	bb 70 00 00 00       	mov    $0x70,%ebx
80102545:	8d 76 00             	lea    0x0(%esi),%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80102548:	89 f0                	mov    %esi,%eax
8010254a:	e8 c9 fd ff ff       	call   80102318 <fill_rtcdate>
8010254f:	b0 0a                	mov    $0xa,%al
80102551:	89 da                	mov    %ebx,%edx
80102553:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102554:	ba 71 00 00 00       	mov    $0x71,%edx
80102559:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010255a:	84 c0                	test   %al,%al
8010255c:	78 ea                	js     80102548 <cmostime+0x28>
        continue;
    fill_rtcdate(&t2);
8010255e:	89 f8                	mov    %edi,%eax
80102560:	e8 b3 fd ff ff       	call   80102318 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102565:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
8010256c:	00 
8010256d:	89 7c 24 04          	mov    %edi,0x4(%esp)
80102571:	89 34 24             	mov    %esi,(%esp)
80102574:	e8 57 18 00 00       	call   80103dd0 <memcmp>
80102579:	85 c0                	test   %eax,%eax
8010257b:	75 cb                	jne    80102548 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
8010257d:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
80102581:	75 78                	jne    801025fb <cmostime+0xdb>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102583:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102586:	89 c2                	mov    %eax,%edx
80102588:	c1 ea 04             	shr    $0x4,%edx
8010258b:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010258e:	83 e0 0f             	and    $0xf,%eax
80102591:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102594:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102597:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010259a:	89 c2                	mov    %eax,%edx
8010259c:	c1 ea 04             	shr    $0x4,%edx
8010259f:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025a2:	83 e0 0f             	and    $0xf,%eax
801025a5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025a8:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801025ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
801025ae:	89 c2                	mov    %eax,%edx
801025b0:	c1 ea 04             	shr    $0x4,%edx
801025b3:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025b6:	83 e0 0f             	and    $0xf,%eax
801025b9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025bc:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801025bf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801025c2:	89 c2                	mov    %eax,%edx
801025c4:	c1 ea 04             	shr    $0x4,%edx
801025c7:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025ca:	83 e0 0f             	and    $0xf,%eax
801025cd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025d0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
801025d3:	8b 45 c8             	mov    -0x38(%ebp),%eax
801025d6:	89 c2                	mov    %eax,%edx
801025d8:	c1 ea 04             	shr    $0x4,%edx
801025db:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025de:	83 e0 0f             	and    $0xf,%eax
801025e1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025e4:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
801025e7:	8b 45 cc             	mov    -0x34(%ebp),%eax
801025ea:	89 c2                	mov    %eax,%edx
801025ec:	c1 ea 04             	shr    $0x4,%edx
801025ef:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025f2:	83 e0 0f             	and    $0xf,%eax
801025f5:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025f8:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
801025fb:	b9 06 00 00 00       	mov    $0x6,%ecx
80102600:	8b 7d 08             	mov    0x8(%ebp),%edi
80102603:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
80102605:	8b 45 08             	mov    0x8(%ebp),%eax
80102608:	81 40 14 d0 07 00 00 	addl   $0x7d0,0x14(%eax)
}
8010260f:	83 c4 5c             	add    $0x5c,%esp
80102612:	5b                   	pop    %ebx
80102613:	5e                   	pop    %esi
80102614:	5f                   	pop    %edi
80102615:	5d                   	pop    %ebp
80102616:	c3                   	ret    
80102617:	90                   	nop

80102618 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102618:	55                   	push   %ebp
80102619:	89 e5                	mov    %esp,%ebp
8010261b:	57                   	push   %edi
8010261c:	56                   	push   %esi
8010261d:	53                   	push   %ebx
8010261e:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102621:	31 db                	xor    %ebx,%ebx
80102623:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102628:	85 c0                	test   %eax,%eax
8010262a:	7e 70                	jle    8010269c <install_trans+0x84>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
8010262c:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102631:	01 d8                	add    %ebx,%eax
80102633:	40                   	inc    %eax
80102634:	89 44 24 04          	mov    %eax,0x4(%esp)
80102638:	a1 c4 26 11 80       	mov    0x801126c4,%eax
8010263d:	89 04 24             	mov    %eax,(%esp)
80102640:	e8 6f da ff ff       	call   801000b4 <bread>
80102645:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102647:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
8010264e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102652:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102657:	89 04 24             	mov    %eax,(%esp)
8010265a:	e8 55 da ff ff       	call   801000b4 <bread>
8010265f:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102661:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102668:	00 
80102669:	8d 47 5c             	lea    0x5c(%edi),%eax
8010266c:	89 44 24 04          	mov    %eax,0x4(%esp)
80102670:	8d 46 5c             	lea    0x5c(%esi),%eax
80102673:	89 04 24             	mov    %eax,(%esp)
80102676:	e8 9d 17 00 00       	call   80103e18 <memmove>
    bwrite(dbuf);  // write dst to disk
8010267b:	89 34 24             	mov    %esi,(%esp)
8010267e:	e8 ed da ff ff       	call   80100170 <bwrite>
    brelse(lbuf);
80102683:	89 3c 24             	mov    %edi,(%esp)
80102686:	e8 1d db ff ff       	call   801001a8 <brelse>
    brelse(dbuf);
8010268b:	89 34 24             	mov    %esi,(%esp)
8010268e:	e8 15 db ff ff       	call   801001a8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102693:	43                   	inc    %ebx
80102694:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
8010269a:	7f 90                	jg     8010262c <install_trans+0x14>
  }
}
8010269c:	83 c4 1c             	add    $0x1c,%esp
8010269f:	5b                   	pop    %ebx
801026a0:	5e                   	pop    %esi
801026a1:	5f                   	pop    %edi
801026a2:	5d                   	pop    %ebp
801026a3:	c3                   	ret    

801026a4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801026a4:	55                   	push   %ebp
801026a5:	89 e5                	mov    %esp,%ebp
801026a7:	57                   	push   %edi
801026a8:	56                   	push   %esi
801026a9:	53                   	push   %ebx
801026aa:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
801026ad:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801026b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801026b6:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801026bb:	89 04 24             	mov    %eax,(%esp)
801026be:	e8 f1 d9 ff ff       	call   801000b4 <bread>
801026c3:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801026c5:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
801026cb:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
801026ce:	85 db                	test   %ebx,%ebx
801026d0:	7e 16                	jle    801026e8 <write_head+0x44>
801026d2:	31 d2                	xor    %edx,%edx
801026d4:	8d 70 5c             	lea    0x5c(%eax),%esi
801026d7:	90                   	nop
    hb->block[i] = log.lh.block[i];
801026d8:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
801026df:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801026e3:	42                   	inc    %edx
801026e4:	39 da                	cmp    %ebx,%edx
801026e6:	75 f0                	jne    801026d8 <write_head+0x34>
  }
  bwrite(buf);
801026e8:	89 3c 24             	mov    %edi,(%esp)
801026eb:	e8 80 da ff ff       	call   80100170 <bwrite>
  brelse(buf);
801026f0:	89 3c 24             	mov    %edi,(%esp)
801026f3:	e8 b0 da ff ff       	call   801001a8 <brelse>
}
801026f8:	83 c4 1c             	add    $0x1c,%esp
801026fb:	5b                   	pop    %ebx
801026fc:	5e                   	pop    %esi
801026fd:	5f                   	pop    %edi
801026fe:	5d                   	pop    %ebp
801026ff:	c3                   	ret    

80102700 <initlog>:
{
80102700:	55                   	push   %ebp
80102701:	89 e5                	mov    %esp,%ebp
80102703:	56                   	push   %esi
80102704:	53                   	push   %ebx
80102705:	83 ec 30             	sub    $0x30,%esp
80102708:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
8010270b:	c7 44 24 04 b0 70 10 	movl   $0x801070b0,0x4(%esp)
80102712:	80 
80102713:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
8010271a:	e8 99 14 00 00       	call   80103bb8 <initlock>
  readsb(dev, &sb);
8010271f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102722:	89 44 24 04          	mov    %eax,0x4(%esp)
80102726:	89 1c 24             	mov    %ebx,(%esp)
80102729:	e8 32 eb ff ff       	call   80101260 <readsb>
  log.start = sb.logstart;
8010272e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102731:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102736:	8b 55 e8             	mov    -0x18(%ebp),%edx
80102739:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.dev = dev;
8010273f:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102745:	89 44 24 04          	mov    %eax,0x4(%esp)
80102749:	89 1c 24             	mov    %ebx,(%esp)
8010274c:	e8 63 d9 ff ff       	call   801000b4 <bread>
  log.lh.n = lh->n;
80102751:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102754:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
8010275a:	85 db                	test   %ebx,%ebx
8010275c:	7e 16                	jle    80102774 <initlog+0x74>
8010275e:	31 d2                	xor    %edx,%edx
80102760:	8d 70 5c             	lea    0x5c(%eax),%esi
80102763:	90                   	nop
    log.lh.block[i] = lh->block[i];
80102764:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102768:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
8010276f:	42                   	inc    %edx
80102770:	39 da                	cmp    %ebx,%edx
80102772:	75 f0                	jne    80102764 <initlog+0x64>
  brelse(buf);
80102774:	89 04 24             	mov    %eax,(%esp)
80102777:	e8 2c da ff ff       	call   801001a8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
8010277c:	e8 97 fe ff ff       	call   80102618 <install_trans>
  log.lh.n = 0;
80102781:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102788:	00 00 00 
  write_head(); // clear the log
8010278b:	e8 14 ff ff ff       	call   801026a4 <write_head>
}
80102790:	83 c4 30             	add    $0x30,%esp
80102793:	5b                   	pop    %ebx
80102794:	5e                   	pop    %esi
80102795:	5d                   	pop    %ebp
80102796:	c3                   	ret    
80102797:	90                   	nop

80102798 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102798:	55                   	push   %ebp
80102799:	89 e5                	mov    %esp,%ebp
8010279b:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
8010279e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801027a5:	e8 d6 14 00 00       	call   80103c80 <acquire>
801027aa:	eb 14                	jmp    801027c0 <begin_op+0x28>
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801027ac:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
801027b3:	80 
801027b4:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801027bb:	e8 fc 0f 00 00       	call   801037bc <sleep>
    if(log.committing){
801027c0:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
801027c6:	85 d2                	test   %edx,%edx
801027c8:	75 e2                	jne    801027ac <begin_op+0x14>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801027ca:	a1 bc 26 11 80       	mov    0x801126bc,%eax
801027cf:	40                   	inc    %eax
801027d0:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
801027d3:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
801027d9:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801027dc:	83 fa 1e             	cmp    $0x1e,%edx
801027df:	7f cb                	jg     801027ac <begin_op+0x14>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
801027e1:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
801027e6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801027ed:	e8 4a 15 00 00       	call   80103d3c <release>
      break;
    }
  }
}
801027f2:	c9                   	leave  
801027f3:	c3                   	ret    

801027f4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801027f4:	55                   	push   %ebp
801027f5:	89 e5                	mov    %esp,%ebp
801027f7:	57                   	push   %edi
801027f8:	56                   	push   %esi
801027f9:	53                   	push   %ebx
801027fa:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
801027fd:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102804:	e8 77 14 00 00       	call   80103c80 <acquire>
  log.outstanding -= 1;
80102809:	a1 bc 26 11 80       	mov    0x801126bc,%eax
8010280e:	48                   	dec    %eax
8010280f:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102814:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
8010281a:	85 db                	test   %ebx,%ebx
8010281c:	0f 85 ed 00 00 00    	jne    8010290f <end_op+0x11b>
    panic("log.committing");
  if(log.outstanding == 0){
80102822:	85 c0                	test   %eax,%eax
80102824:	0f 85 c5 00 00 00    	jne    801028ef <end_op+0xfb>
    do_commit = 1;
    log.committing = 1;
8010282a:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102831:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102834:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
8010283b:	e8 fc 14 00 00       	call   80103d3c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102840:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
80102846:	85 c9                	test   %ecx,%ecx
80102848:	0f 8e 8b 00 00 00    	jle    801028d9 <end_op+0xe5>
8010284e:	31 db                	xor    %ebx,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102850:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102855:	01 d8                	add    %ebx,%eax
80102857:	40                   	inc    %eax
80102858:	89 44 24 04          	mov    %eax,0x4(%esp)
8010285c:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102861:	89 04 24             	mov    %eax,(%esp)
80102864:	e8 4b d8 ff ff       	call   801000b4 <bread>
80102869:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010286b:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
80102872:	89 44 24 04          	mov    %eax,0x4(%esp)
80102876:	a1 c4 26 11 80       	mov    0x801126c4,%eax
8010287b:	89 04 24             	mov    %eax,(%esp)
8010287e:	e8 31 d8 ff ff       	call   801000b4 <bread>
80102883:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102885:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
8010288c:	00 
8010288d:	8d 40 5c             	lea    0x5c(%eax),%eax
80102890:	89 44 24 04          	mov    %eax,0x4(%esp)
80102894:	8d 46 5c             	lea    0x5c(%esi),%eax
80102897:	89 04 24             	mov    %eax,(%esp)
8010289a:	e8 79 15 00 00       	call   80103e18 <memmove>
    bwrite(to);  // write the log
8010289f:	89 34 24             	mov    %esi,(%esp)
801028a2:	e8 c9 d8 ff ff       	call   80100170 <bwrite>
    brelse(from);
801028a7:	89 3c 24             	mov    %edi,(%esp)
801028aa:	e8 f9 d8 ff ff       	call   801001a8 <brelse>
    brelse(to);
801028af:	89 34 24             	mov    %esi,(%esp)
801028b2:	e8 f1 d8 ff ff       	call   801001a8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801028b7:	43                   	inc    %ebx
801028b8:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
801028be:	7c 90                	jl     80102850 <end_op+0x5c>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
801028c0:	e8 df fd ff ff       	call   801026a4 <write_head>
    install_trans(); // Now install writes to home locations
801028c5:	e8 4e fd ff ff       	call   80102618 <install_trans>
    log.lh.n = 0;
801028ca:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
801028d1:	00 00 00 
    write_head();    // Erase the transaction from the log
801028d4:	e8 cb fd ff ff       	call   801026a4 <write_head>
    acquire(&log.lock);
801028d9:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801028e0:	e8 9b 13 00 00       	call   80103c80 <acquire>
    log.committing = 0;
801028e5:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
801028ec:	00 00 00 
    wakeup(&log);
801028ef:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801028f6:	e8 41 10 00 00       	call   8010393c <wakeup>
    release(&log.lock);
801028fb:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102902:	e8 35 14 00 00       	call   80103d3c <release>
}
80102907:	83 c4 1c             	add    $0x1c,%esp
8010290a:	5b                   	pop    %ebx
8010290b:	5e                   	pop    %esi
8010290c:	5f                   	pop    %edi
8010290d:	5d                   	pop    %ebp
8010290e:	c3                   	ret    
    panic("log.committing");
8010290f:	c7 04 24 b4 70 10 80 	movl   $0x801070b4,(%esp)
80102916:	e8 f5 d9 ff ff       	call   80100310 <panic>
8010291b:	90                   	nop

8010291c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
8010291c:	55                   	push   %ebp
8010291d:	89 e5                	mov    %esp,%ebp
8010291f:	53                   	push   %ebx
80102920:	83 ec 14             	sub    $0x14,%esp
80102923:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102926:	a1 c8 26 11 80       	mov    0x801126c8,%eax
8010292b:	83 f8 1d             	cmp    $0x1d,%eax
8010292e:	0f 8f 84 00 00 00    	jg     801029b8 <log_write+0x9c>
80102934:	8b 15 b8 26 11 80    	mov    0x801126b8,%edx
8010293a:	4a                   	dec    %edx
8010293b:	39 d0                	cmp    %edx,%eax
8010293d:	7d 79                	jge    801029b8 <log_write+0x9c>
    panic("too big a transaction");
  if (log.outstanding < 1)
8010293f:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102944:	85 c0                	test   %eax,%eax
80102946:	7e 7c                	jle    801029c4 <log_write+0xa8>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102948:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
8010294f:	e8 2c 13 00 00       	call   80103c80 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102954:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
8010295a:	83 fa 00             	cmp    $0x0,%edx
8010295d:	7e 4a                	jle    801029a9 <log_write+0x8d>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010295f:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102962:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102964:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
8010296a:	75 0d                	jne    80102979 <log_write+0x5d>
8010296c:	eb 32                	jmp    801029a0 <log_write+0x84>
8010296e:	66 90                	xchg   %ax,%ax
80102970:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102977:	74 27                	je     801029a0 <log_write+0x84>
  for (i = 0; i < log.lh.n; i++) {
80102979:	40                   	inc    %eax
8010297a:	39 d0                	cmp    %edx,%eax
8010297c:	75 f2                	jne    80102970 <log_write+0x54>
      break;
  }
  log.lh.block[i] = b->blockno;
8010297e:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102985:	42                   	inc    %edx
80102986:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
8010298c:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
8010298f:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102996:	83 c4 14             	add    $0x14,%esp
80102999:	5b                   	pop    %ebx
8010299a:	5d                   	pop    %ebp
  release(&log.lock);
8010299b:	e9 9c 13 00 00       	jmp    80103d3c <release>
  log.lh.block[i] = b->blockno;
801029a0:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
801029a7:	eb e3                	jmp    8010298c <log_write+0x70>
801029a9:	8b 43 08             	mov    0x8(%ebx),%eax
801029ac:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
801029b1:	75 d9                	jne    8010298c <log_write+0x70>
801029b3:	eb d0                	jmp    80102985 <log_write+0x69>
801029b5:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
801029b8:	c7 04 24 c3 70 10 80 	movl   $0x801070c3,(%esp)
801029bf:	e8 4c d9 ff ff       	call   80100310 <panic>
    panic("log_write outside of trans");
801029c4:	c7 04 24 d9 70 10 80 	movl   $0x801070d9,(%esp)
801029cb:	e8 40 d9 ff ff       	call   80100310 <panic>

801029d0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801029d0:	55                   	push   %ebp
801029d1:	89 e5                	mov    %esp,%ebp
801029d3:	53                   	push   %ebx
801029d4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801029d7:	e8 80 08 00 00       	call   8010325c <cpuid>
801029dc:	89 c3                	mov    %eax,%ebx
801029de:	e8 79 08 00 00       	call   8010325c <cpuid>
801029e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801029e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801029eb:	c7 04 24 f4 70 10 80 	movl   $0x801070f4,(%esp)
801029f2:	e8 bd db ff ff       	call   801005b4 <cprintf>
  idtinit();       // load idt register
801029f7:	e8 60 24 00 00       	call   80104e5c <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801029fc:	e8 e7 07 00 00       	call   801031e8 <mycpu>
80102a01:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102a03:	b8 01 00 00 00       	mov    $0x1,%eax
80102a08:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102a0f:	e8 84 3e 00 00       	call   80106898 <scheduler>

80102a14 <mpenter>:
{
80102a14:	55                   	push   %ebp
80102a15:	89 e5                	mov    %esp,%ebp
80102a17:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102a1a:	e8 1d 34 00 00       	call   80105e3c <switchkvm>
  seginit();
80102a1f:	e8 3c 33 00 00       	call   80105d60 <seginit>
  lapicinit();
80102a24:	e8 53 f9 ff ff       	call   8010237c <lapicinit>
  mpmain();
80102a29:	e8 a2 ff ff ff       	call   801029d0 <mpmain>
80102a2e:	66 90                	xchg   %ax,%ax

80102a30 <main>:
{
80102a30:	55                   	push   %ebp
80102a31:	89 e5                	mov    %esp,%ebp
80102a33:	53                   	push   %ebx
80102a34:	83 e4 f0             	and    $0xfffffff0,%esp
80102a37:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102a3a:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102a41:	80 
80102a42:	c7 04 24 d8 5f 11 80 	movl   $0x80115fd8,(%esp)
80102a49:	e8 5e f7 ff ff       	call   801021ac <kinit1>
  kvmalloc();      // kernel page table
80102a4e:	e8 f9 38 00 00       	call   8010634c <kvmalloc>
  mpinit();        // detect other processors
80102a53:	e8 54 01 00 00       	call   80102bac <mpinit>
  lapicinit();     // interrupt controller
80102a58:	e8 1f f9 ff ff       	call   8010237c <lapicinit>
  seginit();       // segment descriptors
80102a5d:	e8 fe 32 00 00       	call   80105d60 <seginit>
  picinit();       // disable pic
80102a62:	e8 ed 02 00 00       	call   80102d54 <picinit>
  ioapicinit();    // another interrupt controller
80102a67:	e8 70 f5 ff ff       	call   80101fdc <ioapicinit>
  consoleinit();   // console hardware
80102a6c:	e8 1b de ff ff       	call   8010088c <consoleinit>
  uartinit();      // serial port
80102a71:	e8 d6 26 00 00       	call   8010514c <uartinit>
  pinit();         // process table
80102a76:	e8 51 07 00 00       	call   801031cc <pinit>
  tvinit();        // trap vectors
80102a7b:	e8 54 23 00 00       	call   80104dd4 <tvinit>
  binit();         // buffer cache
80102a80:	e8 af d5 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80102a85:	e8 f2 e1 ff ff       	call   80100c7c <fileinit>
  ideinit();       // disk 
80102a8a:	e8 6d f3 ff ff       	call   80101dfc <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102a8f:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102a96:	00 
80102a97:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102a9e:	80 
80102a9f:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102aa6:	e8 6d 13 00 00       	call   80103e18 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102aab:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80102ab0:	8d 14 80             	lea    (%eax,%eax,4),%edx
80102ab3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102ab6:	c1 e0 04             	shl    $0x4,%eax
80102ab9:	05 80 27 11 80       	add    $0x80112780,%eax
80102abe:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102ac3:	39 d8                	cmp    %ebx,%eax
80102ac5:	76 68                	jbe    80102b2f <main+0xff>
80102ac7:	90                   	nop
    if(c == mycpu())  // We've started already.
80102ac8:	e8 1b 07 00 00       	call   801031e8 <mycpu>
80102acd:	39 d8                	cmp    %ebx,%eax
80102acf:	74 41                	je     80102b12 <main+0xe2>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ad1:	e8 16 f7 ff ff       	call   801021ec <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ad6:	05 00 10 00 00       	add    $0x1000,%eax
80102adb:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void**)(code-8) = mpenter;
80102ae0:	c7 05 f8 6f 00 80 14 	movl   $0x80102a14,0x80006ff8
80102ae7:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102aea:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102af1:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102af4:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102afb:	00 
80102afc:	0f b6 03             	movzbl (%ebx),%eax
80102aff:	89 04 24             	mov    %eax,(%esp)
80102b02:	e8 95 f9 ff ff       	call   8010249c <lapicstartap>
80102b07:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102b08:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102b0e:	85 c0                	test   %eax,%eax
80102b10:	74 f6                	je     80102b08 <main+0xd8>
  for(c = cpus; c < cpus+ncpu; c++){
80102b12:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102b18:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80102b1d:	8d 14 80             	lea    (%eax,%eax,4),%edx
80102b20:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b23:	c1 e0 04             	shl    $0x4,%eax
80102b26:	05 80 27 11 80       	add    $0x80112780,%eax
80102b2b:	39 c3                	cmp    %eax,%ebx
80102b2d:	72 99                	jb     80102ac8 <main+0x98>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102b2f:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102b36:	8e 
80102b37:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102b3e:	e8 45 f6 ff ff       	call   80102188 <kinit2>
  userinit();      // first user process
80102b43:	e8 68 07 00 00       	call   801032b0 <userinit>
  mpmain();        // finish this processor's setup
80102b48:	e8 83 fe ff ff       	call   801029d0 <mpmain>
80102b4d:	66 90                	xchg   %ax,%ax
80102b4f:	90                   	nop

80102b50 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
80102b53:	57                   	push   %edi
80102b54:	56                   	push   %esi
80102b55:	53                   	push   %ebx
80102b56:	83 ec 1c             	sub    $0x1c,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
80102b59:	8d b8 00 00 00 80    	lea    -0x80000000(%eax),%edi
  e = addr+len;
80102b5f:	8d 1c 17             	lea    (%edi,%edx,1),%ebx
  for(p = addr; p < e; p += sizeof(struct mp))
80102b62:	39 df                	cmp    %ebx,%edi
80102b64:	73 39                	jae    80102b9f <mpsearch1+0x4f>
80102b66:	66 90                	xchg   %ax,%ax
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102b68:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102b6f:	00 
80102b70:	c7 44 24 04 08 71 10 	movl   $0x80107108,0x4(%esp)
80102b77:	80 
80102b78:	89 3c 24             	mov    %edi,(%esp)
80102b7b:	e8 50 12 00 00       	call   80103dd0 <memcmp>
80102b80:	85 c0                	test   %eax,%eax
80102b82:	75 14                	jne    80102b98 <mpsearch1+0x48>
80102b84:	31 c9                	xor    %ecx,%ecx
80102b86:	31 d2                	xor    %edx,%edx
    sum += addr[i];
80102b88:	0f b6 34 17          	movzbl (%edi,%edx,1),%esi
80102b8c:	01 f1                	add    %esi,%ecx
  for(i=0; i<len; i++)
80102b8e:	42                   	inc    %edx
80102b8f:	83 fa 10             	cmp    $0x10,%edx
80102b92:	75 f4                	jne    80102b88 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102b94:	84 c9                	test   %cl,%cl
80102b96:	74 09                	je     80102ba1 <mpsearch1+0x51>
  for(p = addr; p < e; p += sizeof(struct mp))
80102b98:	83 c7 10             	add    $0x10,%edi
80102b9b:	39 fb                	cmp    %edi,%ebx
80102b9d:	77 c9                	ja     80102b68 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
80102b9f:	31 ff                	xor    %edi,%edi
}
80102ba1:	89 f8                	mov    %edi,%eax
80102ba3:	83 c4 1c             	add    $0x1c,%esp
80102ba6:	5b                   	pop    %ebx
80102ba7:	5e                   	pop    %esi
80102ba8:	5f                   	pop    %edi
80102ba9:	5d                   	pop    %ebp
80102baa:	c3                   	ret    
80102bab:	90                   	nop

80102bac <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102bac:	55                   	push   %ebp
80102bad:	89 e5                	mov    %esp,%ebp
80102baf:	57                   	push   %edi
80102bb0:	56                   	push   %esi
80102bb1:	53                   	push   %ebx
80102bb2:	83 ec 2c             	sub    $0x2c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102bb5:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102bbc:	c1 e0 08             	shl    $0x8,%eax
80102bbf:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102bc6:	09 d0                	or     %edx,%eax
80102bc8:	c1 e0 04             	shl    $0x4,%eax
80102bcb:	75 1b                	jne    80102be8 <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102bcd:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102bd4:	c1 e0 08             	shl    $0x8,%eax
80102bd7:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102bde:	09 d0                	or     %edx,%eax
80102be0:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102be3:	2d 00 04 00 00       	sub    $0x400,%eax
80102be8:	ba 00 04 00 00       	mov    $0x400,%edx
80102bed:	e8 5e ff ff ff       	call   80102b50 <mpsearch1>
80102bf2:	89 c7                	mov    %eax,%edi
80102bf4:	85 c0                	test   %eax,%eax
80102bf6:	0f 84 25 01 00 00    	je     80102d21 <mpinit+0x175>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102bfc:	8b 5f 04             	mov    0x4(%edi),%ebx
80102bff:	85 db                	test   %ebx,%ebx
80102c01:	0f 84 35 01 00 00    	je     80102d3c <mpinit+0x190>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102c07:	8d 93 00 00 00 80    	lea    -0x80000000(%ebx),%edx
80102c0d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80102c10:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102c17:	00 
80102c18:	c7 44 24 04 0d 71 10 	movl   $0x8010710d,0x4(%esp)
80102c1f:	80 
80102c20:	89 14 24             	mov    %edx,(%esp)
80102c23:	e8 a8 11 00 00       	call   80103dd0 <memcmp>
80102c28:	85 c0                	test   %eax,%eax
80102c2a:	0f 85 0c 01 00 00    	jne    80102d3c <mpinit+0x190>
  if(conf->version != 1 && conf->version != 4)
80102c30:	8a 83 06 00 00 80    	mov    -0x7ffffffa(%ebx),%al
80102c36:	3c 01                	cmp    $0x1,%al
80102c38:	74 08                	je     80102c42 <mpinit+0x96>
80102c3a:	3c 04                	cmp    $0x4,%al
80102c3c:	0f 85 fa 00 00 00    	jne    80102d3c <mpinit+0x190>
  if(sum((uchar*)conf, conf->length) != 0)
80102c42:	0f b7 83 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%eax
  for(i=0; i<len; i++)
80102c49:	85 c0                	test   %eax,%eax
80102c4b:	74 1e                	je     80102c6b <mpinit+0xbf>
80102c4d:	31 c9                	xor    %ecx,%ecx
80102c4f:	31 d2                	xor    %edx,%edx
80102c51:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80102c54:	0f b6 b4 13 00 00 00 	movzbl -0x80000000(%ebx,%edx,1),%esi
80102c5b:	80 
80102c5c:	01 f1                	add    %esi,%ecx
  for(i=0; i<len; i++)
80102c5e:	42                   	inc    %edx
80102c5f:	39 d0                	cmp    %edx,%eax
80102c61:	7f f1                	jg     80102c54 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80102c63:	84 c9                	test   %cl,%cl
80102c65:	0f 85 d1 00 00 00    	jne    80102d3c <mpinit+0x190>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102c6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102c6e:	85 c0                	test   %eax,%eax
80102c70:	0f 84 c6 00 00 00    	je     80102d3c <mpinit+0x190>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102c76:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
80102c7c:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102c81:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
80102c87:	0f b7 8b 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%ecx
80102c8e:	03 4d e4             	add    -0x1c(%ebp),%ecx
  ismp = 1;
80102c91:	bb 01 00 00 00       	mov    $0x1,%ebx
80102c96:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80102c99:	8d 76 00             	lea    0x0(%esi),%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102c9c:	39 c1                	cmp    %eax,%ecx
80102c9e:	76 23                	jbe    80102cc3 <mpinit+0x117>
80102ca0:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
80102ca3:	80 fa 04             	cmp    $0x4,%dl
80102ca6:	76 0c                	jbe    80102cb4 <mpinit+0x108>
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80102ca8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    switch(*p){
80102caf:	80 fa 04             	cmp    $0x4,%dl
80102cb2:	77 f4                	ja     80102ca8 <mpinit+0xfc>
80102cb4:	ff 24 95 4c 71 10 80 	jmp    *-0x7fef8eb4(,%edx,4)
80102cbb:	90                   	nop
      p += 8;
80102cbc:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102cbf:	39 c1                	cmp    %eax,%ecx
80102cc1:	77 dd                	ja     80102ca0 <mpinit+0xf4>
80102cc3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
      break;
    }
  }
  if(!ismp)
80102cc6:	85 db                	test   %ebx,%ebx
80102cc8:	74 7e                	je     80102d48 <mpinit+0x19c>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102cca:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
80102cce:	74 0f                	je     80102cdf <mpinit+0x133>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cd0:	ba 22 00 00 00       	mov    $0x22,%edx
80102cd5:	b0 70                	mov    $0x70,%al
80102cd7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cd8:	b2 23                	mov    $0x23,%dl
80102cda:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102cdb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102cde:	ee                   	out    %al,(%dx)
  }
}
80102cdf:	83 c4 2c             	add    $0x2c,%esp
80102ce2:	5b                   	pop    %ebx
80102ce3:	5e                   	pop    %esi
80102ce4:	5f                   	pop    %edi
80102ce5:	5d                   	pop    %ebp
80102ce6:	c3                   	ret    
80102ce7:	90                   	nop
      if(ncpu < NCPU) {
80102ce8:	8b 15 00 2d 11 80    	mov    0x80112d00,%edx
80102cee:	83 fa 07             	cmp    $0x7,%edx
80102cf1:	7f 18                	jg     80102d0b <mpinit+0x15f>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102cf3:	8d 34 92             	lea    (%edx,%edx,4),%esi
80102cf6:	8d 14 72             	lea    (%edx,%esi,2),%edx
80102cf9:	c1 e2 04             	shl    $0x4,%edx
80102cfc:	8a 58 01             	mov    0x1(%eax),%bl
80102cff:	88 9a 80 27 11 80    	mov    %bl,-0x7feed880(%edx)
        ncpu++;
80102d05:	ff 05 00 2d 11 80    	incl   0x80112d00
      p += sizeof(struct mpproc);
80102d0b:	83 c0 14             	add    $0x14,%eax
      continue;
80102d0e:	eb 8c                	jmp    80102c9c <mpinit+0xf0>
      ioapicid = ioapic->apicno;
80102d10:	8a 50 01             	mov    0x1(%eax),%dl
80102d13:	88 15 60 27 11 80    	mov    %dl,0x80112760
      p += sizeof(struct mpioapic);
80102d19:	83 c0 08             	add    $0x8,%eax
      continue;
80102d1c:	e9 7b ff ff ff       	jmp    80102c9c <mpinit+0xf0>
  return mpsearch1(0xF0000, 0x10000);
80102d21:	ba 00 00 01 00       	mov    $0x10000,%edx
80102d26:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102d2b:	e8 20 fe ff ff       	call   80102b50 <mpsearch1>
80102d30:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102d32:	85 c0                	test   %eax,%eax
80102d34:	0f 85 c2 fe ff ff    	jne    80102bfc <mpinit+0x50>
80102d3a:	66 90                	xchg   %ax,%ax
    panic("Expect to run on an SMP");
80102d3c:	c7 04 24 12 71 10 80 	movl   $0x80107112,(%esp)
80102d43:	e8 c8 d5 ff ff       	call   80100310 <panic>
    panic("Didn't find a suitable machine");
80102d48:	c7 04 24 2c 71 10 80 	movl   $0x8010712c,(%esp)
80102d4f:	e8 bc d5 ff ff       	call   80100310 <panic>

80102d54 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80102d54:	55                   	push   %ebp
80102d55:	89 e5                	mov    %esp,%ebp
80102d57:	ba 21 00 00 00       	mov    $0x21,%edx
80102d5c:	b0 ff                	mov    $0xff,%al
80102d5e:	ee                   	out    %al,(%dx)
80102d5f:	b2 a1                	mov    $0xa1,%dl
80102d61:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102d62:	5d                   	pop    %ebp
80102d63:	c3                   	ret    

80102d64 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102d64:	55                   	push   %ebp
80102d65:	89 e5                	mov    %esp,%ebp
80102d67:	56                   	push   %esi
80102d68:	53                   	push   %ebx
80102d69:	83 ec 20             	sub    $0x20,%esp
80102d6c:	8b 75 08             	mov    0x8(%ebp),%esi
80102d6f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102d72:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80102d78:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102d7e:	e8 15 df ff ff       	call   80100c98 <filealloc>
80102d83:	89 06                	mov    %eax,(%esi)
80102d85:	85 c0                	test   %eax,%eax
80102d87:	0f 84 a1 00 00 00    	je     80102e2e <pipealloc+0xca>
80102d8d:	e8 06 df ff ff       	call   80100c98 <filealloc>
80102d92:	89 03                	mov    %eax,(%ebx)
80102d94:	85 c0                	test   %eax,%eax
80102d96:	0f 84 84 00 00 00    	je     80102e20 <pipealloc+0xbc>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102d9c:	e8 4b f4 ff ff       	call   801021ec <kalloc>
80102da1:	85 c0                	test   %eax,%eax
80102da3:	74 7b                	je     80102e20 <pipealloc+0xbc>
    goto bad;
  p->readopen = 1;
80102da5:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102dac:	00 00 00 
  p->writeopen = 1;
80102daf:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102db6:	00 00 00 
  p->nwrite = 0;
80102db9:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102dc0:	00 00 00 
  p->nread = 0;
80102dc3:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102dca:	00 00 00 
  initlock(&p->lock, "pipe");
80102dcd:	c7 44 24 04 60 71 10 	movl   $0x80107160,0x4(%esp)
80102dd4:	80 
80102dd5:	89 04 24             	mov    %eax,(%esp)
80102dd8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102ddb:	e8 d8 0d 00 00       	call   80103bb8 <initlock>
  (*f0)->type = FD_PIPE;
80102de0:	8b 16                	mov    (%esi),%edx
80102de2:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
  (*f0)->readable = 1;
80102de8:	8b 16                	mov    (%esi),%edx
80102dea:	c6 42 08 01          	movb   $0x1,0x8(%edx)
  (*f0)->writable = 0;
80102dee:	8b 16                	mov    (%esi),%edx
80102df0:	c6 42 09 00          	movb   $0x0,0x9(%edx)
  (*f0)->pipe = p;
80102df4:	8b 16                	mov    (%esi),%edx
80102df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102df9:	89 42 0c             	mov    %eax,0xc(%edx)
  (*f1)->type = FD_PIPE;
80102dfc:	8b 13                	mov    (%ebx),%edx
80102dfe:	c7 02 01 00 00 00    	movl   $0x1,(%edx)
  (*f1)->readable = 0;
80102e04:	8b 13                	mov    (%ebx),%edx
80102e06:	c6 42 08 00          	movb   $0x0,0x8(%edx)
  (*f1)->writable = 1;
80102e0a:	8b 13                	mov    (%ebx),%edx
80102e0c:	c6 42 09 01          	movb   $0x1,0x9(%edx)
  (*f1)->pipe = p;
80102e10:	8b 13                	mov    (%ebx),%edx
80102e12:	89 42 0c             	mov    %eax,0xc(%edx)
  return 0;
80102e15:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80102e17:	83 c4 20             	add    $0x20,%esp
80102e1a:	5b                   	pop    %ebx
80102e1b:	5e                   	pop    %esi
80102e1c:	5d                   	pop    %ebp
80102e1d:	c3                   	ret    
80102e1e:	66 90                	xchg   %ax,%ax
  if(*f0)
80102e20:	8b 06                	mov    (%esi),%eax
80102e22:	85 c0                	test   %eax,%eax
80102e24:	74 08                	je     80102e2e <pipealloc+0xca>
    fileclose(*f0);
80102e26:	89 04 24             	mov    %eax,(%esp)
80102e29:	e8 12 df ff ff       	call   80100d40 <fileclose>
  if(*f1)
80102e2e:	8b 03                	mov    (%ebx),%eax
80102e30:	85 c0                	test   %eax,%eax
80102e32:	74 14                	je     80102e48 <pipealloc+0xe4>
    fileclose(*f1);
80102e34:	89 04 24             	mov    %eax,(%esp)
80102e37:	e8 04 df ff ff       	call   80100d40 <fileclose>
  return -1;
80102e3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e41:	83 c4 20             	add    $0x20,%esp
80102e44:	5b                   	pop    %ebx
80102e45:	5e                   	pop    %esi
80102e46:	5d                   	pop    %ebp
80102e47:	c3                   	ret    
  return -1;
80102e48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102e4d:	83 c4 20             	add    $0x20,%esp
80102e50:	5b                   	pop    %ebx
80102e51:	5e                   	pop    %esi
80102e52:	5d                   	pop    %ebp
80102e53:	c3                   	ret    

80102e54 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102e54:	55                   	push   %ebp
80102e55:	89 e5                	mov    %esp,%ebp
80102e57:	56                   	push   %esi
80102e58:	53                   	push   %ebx
80102e59:	83 ec 10             	sub    $0x10,%esp
80102e5c:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e5f:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
80102e62:	89 1c 24             	mov    %ebx,(%esp)
80102e65:	e8 16 0e 00 00       	call   80103c80 <acquire>
  if(writable){
80102e6a:	85 f6                	test   %esi,%esi
80102e6c:	74 3a                	je     80102ea8 <pipeclose+0x54>
    p->writeopen = 0;
80102e6e:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102e75:	00 00 00 
    wakeup(&p->nread);
80102e78:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e7e:	89 04 24             	mov    %eax,(%esp)
80102e81:	e8 b6 0a 00 00       	call   8010393c <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102e86:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
80102e8c:	85 d2                	test   %edx,%edx
80102e8e:	75 0a                	jne    80102e9a <pipeclose+0x46>
80102e90:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80102e96:	85 c0                	test   %eax,%eax
80102e98:	74 2a                	je     80102ec4 <pipeclose+0x70>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102e9a:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80102e9d:	83 c4 10             	add    $0x10,%esp
80102ea0:	5b                   	pop    %ebx
80102ea1:	5e                   	pop    %esi
80102ea2:	5d                   	pop    %ebp
    release(&p->lock);
80102ea3:	e9 94 0e 00 00       	jmp    80103d3c <release>
    p->readopen = 0;
80102ea8:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102eaf:	00 00 00 
    wakeup(&p->nwrite);
80102eb2:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102eb8:	89 04 24             	mov    %eax,(%esp)
80102ebb:	e8 7c 0a 00 00       	call   8010393c <wakeup>
80102ec0:	eb c4                	jmp    80102e86 <pipeclose+0x32>
80102ec2:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80102ec4:	89 1c 24             	mov    %ebx,(%esp)
80102ec7:	e8 70 0e 00 00       	call   80103d3c <release>
    kfree((char*)p);
80102ecc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80102ecf:	83 c4 10             	add    $0x10,%esp
80102ed2:	5b                   	pop    %ebx
80102ed3:	5e                   	pop    %esi
80102ed4:	5d                   	pop    %ebp
    kfree((char*)p);
80102ed5:	e9 d6 f1 ff ff       	jmp    801020b0 <kfree>
80102eda:	66 90                	xchg   %ax,%ax

80102edc <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102edc:	55                   	push   %ebp
80102edd:	89 e5                	mov    %esp,%ebp
80102edf:	57                   	push   %edi
80102ee0:	56                   	push   %esi
80102ee1:	53                   	push   %ebx
80102ee2:	83 ec 2c             	sub    $0x2c,%esp
80102ee5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102ee8:	89 1c 24             	mov    %ebx,(%esp)
80102eeb:	e8 90 0d 00 00       	call   80103c80 <acquire>
  for(i = 0; i < n; i++){
80102ef0:	8b 45 10             	mov    0x10(%ebp),%eax
80102ef3:	85 c0                	test   %eax,%eax
80102ef5:	0f 8e 84 00 00 00    	jle    80102f7f <pipewrite+0xa3>
80102efb:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80102f01:	8b 55 0c             	mov    0xc(%ebp),%edx
80102f04:	89 55 e4             	mov    %edx,-0x1c(%ebp)
pipewrite(struct pipe *p, char *addr, int n)
80102f07:	03 55 10             	add    0x10(%ebp),%edx
80102f0a:	89 55 e0             	mov    %edx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80102f0d:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102f13:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80102f19:	eb 31                	jmp    80102f4c <pipewrite+0x70>
80102f1b:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80102f1c:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80102f22:	85 c0                	test   %eax,%eax
80102f24:	74 72                	je     80102f98 <pipewrite+0xbc>
80102f26:	e8 65 03 00 00       	call   80103290 <myproc>
80102f2b:	8b 48 24             	mov    0x24(%eax),%ecx
80102f2e:	85 c9                	test   %ecx,%ecx
80102f30:	75 66                	jne    80102f98 <pipewrite+0xbc>
      wakeup(&p->nread);
80102f32:	89 3c 24             	mov    %edi,(%esp)
80102f35:	e8 02 0a 00 00       	call   8010393c <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102f3a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80102f3e:	89 34 24             	mov    %esi,(%esp)
80102f41:	e8 76 08 00 00       	call   801037bc <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102f46:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80102f4c:	8b 93 34 02 00 00    	mov    0x234(%ebx),%edx
80102f52:	81 c2 00 02 00 00    	add    $0x200,%edx
80102f58:	39 d0                	cmp    %edx,%eax
80102f5a:	74 c0                	je     80102f1c <pipewrite+0x40>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80102f5c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80102f5f:	8a 09                	mov    (%ecx),%cl
80102f61:	89 c2                	mov    %eax,%edx
80102f63:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102f69:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
80102f6d:	40                   	inc    %eax
80102f6e:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80102f74:	ff 45 e4             	incl   -0x1c(%ebp)
  for(i = 0; i < n; i++){
80102f77:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102f7a:	39 55 e4             	cmp    %edx,-0x1c(%ebp)
80102f7d:	75 cd                	jne    80102f4c <pipewrite+0x70>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102f7f:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f85:	89 04 24             	mov    %eax,(%esp)
80102f88:	e8 af 09 00 00       	call   8010393c <wakeup>
  release(&p->lock);
80102f8d:	89 1c 24             	mov    %ebx,(%esp)
80102f90:	e8 a7 0d 00 00       	call   80103d3c <release>
  return n;
80102f95:	eb 10                	jmp    80102fa7 <pipewrite+0xcb>
80102f97:	90                   	nop
        release(&p->lock);
80102f98:	89 1c 24             	mov    %ebx,(%esp)
80102f9b:	e8 9c 0d 00 00       	call   80103d3c <release>
        return -1;
80102fa0:	c7 45 10 ff ff ff ff 	movl   $0xffffffff,0x10(%ebp)
}
80102fa7:	8b 45 10             	mov    0x10(%ebp),%eax
80102faa:	83 c4 2c             	add    $0x2c,%esp
80102fad:	5b                   	pop    %ebx
80102fae:	5e                   	pop    %esi
80102faf:	5f                   	pop    %edi
80102fb0:	5d                   	pop    %ebp
80102fb1:	c3                   	ret    
80102fb2:	66 90                	xchg   %ax,%ax

80102fb4 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80102fb4:	55                   	push   %ebp
80102fb5:	89 e5                	mov    %esp,%ebp
80102fb7:	57                   	push   %edi
80102fb8:	56                   	push   %esi
80102fb9:	53                   	push   %ebx
80102fba:	83 ec 2c             	sub    $0x2c,%esp
80102fbd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102fc0:	89 1c 24             	mov    %ebx,(%esp)
80102fc3:	e8 b8 0c 00 00       	call   80103c80 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102fc8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80102fce:	3b 8b 38 02 00 00    	cmp    0x238(%ebx),%ecx
80102fd4:	75 5a                	jne    80103030 <piperead+0x7c>
80102fd6:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80102fdc:	85 c0                	test   %eax,%eax
80102fde:	74 50                	je     80103030 <piperead+0x7c>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80102fe0:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
80102fe6:	eb 24                	jmp    8010300c <piperead+0x58>
80102fe8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80102fec:	89 34 24             	mov    %esi,(%esp)
80102fef:	e8 c8 07 00 00       	call   801037bc <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102ff4:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80102ffa:	3b 8b 38 02 00 00    	cmp    0x238(%ebx),%ecx
80103000:	75 2e                	jne    80103030 <piperead+0x7c>
80103002:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103008:	85 c0                	test   %eax,%eax
8010300a:	74 24                	je     80103030 <piperead+0x7c>
    if(myproc()->killed){
8010300c:	e8 7f 02 00 00       	call   80103290 <myproc>
80103011:	8b 40 24             	mov    0x24(%eax),%eax
80103014:	85 c0                	test   %eax,%eax
80103016:	74 d0                	je     80102fe8 <piperead+0x34>
      release(&p->lock);
80103018:	89 1c 24             	mov    %ebx,(%esp)
8010301b:	e8 1c 0d 00 00       	call   80103d3c <release>
      return -1;
80103020:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103025:	83 c4 2c             	add    $0x2c,%esp
80103028:	5b                   	pop    %ebx
80103029:	5e                   	pop    %esi
8010302a:	5f                   	pop    %edi
8010302b:	5d                   	pop    %ebp
8010302c:	c3                   	ret    
8010302d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103030:	8b 45 10             	mov    0x10(%ebp),%eax
80103033:	85 c0                	test   %eax,%eax
80103035:	7e 62                	jle    80103099 <piperead+0xe5>
    if(p->nread == p->nwrite)
80103037:	3b 8b 38 02 00 00    	cmp    0x238(%ebx),%ecx
8010303d:	74 5a                	je     80103099 <piperead+0xe5>
piperead(struct pipe *p, char *addr, int n)
8010303f:	8b 7d 10             	mov    0x10(%ebp),%edi
80103042:	01 cf                	add    %ecx,%edi
80103044:	89 ca                	mov    %ecx,%edx
80103046:	8b 75 0c             	mov    0xc(%ebp),%esi
80103049:	29 ce                	sub    %ecx,%esi
8010304b:	eb 0b                	jmp    80103058 <piperead+0xa4>
8010304d:	8d 76 00             	lea    0x0(%esi),%esi
    if(p->nread == p->nwrite)
80103050:	39 93 38 02 00 00    	cmp    %edx,0x238(%ebx)
80103056:	74 1d                	je     80103075 <piperead+0xc1>
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103058:	89 d0                	mov    %edx,%eax
8010305a:	25 ff 01 00 00       	and    $0x1ff,%eax
8010305f:	8a 44 03 34          	mov    0x34(%ebx,%eax,1),%al
80103063:	88 04 16             	mov    %al,(%esi,%edx,1)
80103066:	42                   	inc    %edx
80103067:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
piperead(struct pipe *p, char *addr, int n)
8010306d:	89 d0                	mov    %edx,%eax
8010306f:	29 c8                	sub    %ecx,%eax
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103071:	39 fa                	cmp    %edi,%edx
80103073:	75 db                	jne    80103050 <piperead+0x9c>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103075:	8d 93 38 02 00 00    	lea    0x238(%ebx),%edx
8010307b:	89 14 24             	mov    %edx,(%esp)
8010307e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103081:	e8 b6 08 00 00       	call   8010393c <wakeup>
  release(&p->lock);
80103086:	89 1c 24             	mov    %ebx,(%esp)
80103089:	e8 ae 0c 00 00       	call   80103d3c <release>
8010308e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80103091:	83 c4 2c             	add    $0x2c,%esp
80103094:	5b                   	pop    %ebx
80103095:	5e                   	pop    %esi
80103096:	5f                   	pop    %edi
80103097:	5d                   	pop    %ebp
80103098:	c3                   	ret    
    if(p->nread == p->nwrite)
80103099:	31 c0                	xor    %eax,%eax
8010309b:	eb d8                	jmp    80103075 <piperead+0xc1>
8010309d:	66 90                	xchg   %ax,%ax
8010309f:	90                   	nop

801030a0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	53                   	push   %ebx
801030a4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801030a7:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801030ae:	e8 cd 0b 00 00       	call   80103c80 <acquire>

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801030b3:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801030b8:	eb 14                	jmp    801030ce <allocproc+0x2e>
801030ba:	66 90                	xchg   %ax,%ax
801030bc:	81 c3 88 00 00 00    	add    $0x88,%ebx
801030c2:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
801030c8:	0f 84 96 00 00 00    	je     80103164 <allocproc+0xc4>
    if(p->state == UNUSED)
801030ce:	8b 43 0c             	mov    0xc(%ebx),%eax
801030d1:	85 c0                	test   %eax,%eax
801030d3:	75 e7                	jne    801030bc <allocproc+0x1c>

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801030d5:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801030dc:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801030e1:	89 43 10             	mov    %eax,0x10(%ebx)
801030e4:	40                   	inc    %eax
801030e5:	a3 00 a0 10 80       	mov    %eax,0x8010a000
  release(&ptable.lock);
801030ea:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801030f1:	e8 46 0c 00 00       	call   80103d3c <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801030f6:	e8 f1 f0 ff ff       	call   801021ec <kalloc>
801030fb:	89 43 08             	mov    %eax,0x8(%ebx)
801030fe:	85 c0                	test   %eax,%eax
80103100:	74 78                	je     8010317a <allocproc+0xda>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103102:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
80103108:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
8010310b:	c7 80 b0 0f 00 00 c9 	movl   $0x80104dc9,0xfb0(%eax)
80103112:	4d 10 80 

  sp -= sizeof *p->context;
80103115:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
8010311a:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010311d:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80103124:	00 
80103125:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010312c:	00 
8010312d:	89 04 24             	mov    %eax,(%esp)
80103130:	e8 4f 0c 00 00       	call   80103d84 <memset>
  p->context->eip = (uint)forkret;
80103135:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103138:	c7 40 10 88 31 10 80 	movl   $0x80103188,0x10(%eax)

  push_MLFQ(0, p);
8010313f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103143:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010314a:	e8 3d 34 00 00       	call   8010658c <push_MLFQ>
  p->myst = s_cand;
8010314f:	c7 83 84 00 00 00 c0 	movl   $0x801157c0,0x84(%ebx)
80103156:	57 11 80 
  return p;
}
80103159:	89 d8                	mov    %ebx,%eax
8010315b:	83 c4 14             	add    $0x14,%esp
8010315e:	5b                   	pop    %ebx
8010315f:	5d                   	pop    %ebp
80103160:	c3                   	ret    
80103161:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103164:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010316b:	e8 cc 0b 00 00       	call   80103d3c <release>
  return 0;
80103170:	31 db                	xor    %ebx,%ebx
}
80103172:	89 d8                	mov    %ebx,%eax
80103174:	83 c4 14             	add    $0x14,%esp
80103177:	5b                   	pop    %ebx
80103178:	5d                   	pop    %ebp
80103179:	c3                   	ret    
    p->state = UNUSED;
8010317a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103181:	31 db                	xor    %ebx,%ebx
80103183:	eb d4                	jmp    80103159 <allocproc+0xb9>
80103185:	8d 76 00             	lea    0x0(%esi),%esi

80103188 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103188:	55                   	push   %ebp
80103189:	89 e5                	mov    %esp,%ebp
8010318b:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
8010318e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103195:	e8 a2 0b 00 00       	call   80103d3c <release>

  if (first) {
8010319a:	8b 15 04 a0 10 80    	mov    0x8010a004,%edx
801031a0:	85 d2                	test   %edx,%edx
801031a2:	75 04                	jne    801031a8 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801031a4:	c9                   	leave  
801031a5:	c3                   	ret    
801031a6:	66 90                	xchg   %ax,%ax
    first = 0;
801031a8:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
801031af:	00 00 00 
    iinit(ROOTDEV);
801031b2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801031b9:	e8 6e e1 ff ff       	call   8010132c <iinit>
    initlog(ROOTDEV);
801031be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801031c5:	e8 36 f5 ff ff       	call   80102700 <initlog>
}
801031ca:	c9                   	leave  
801031cb:	c3                   	ret    

801031cc <pinit>:
{
801031cc:	55                   	push   %ebp
801031cd:	89 e5                	mov    %esp,%ebp
801031cf:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801031d2:	c7 44 24 04 65 71 10 	movl   $0x80107165,0x4(%esp)
801031d9:	80 
801031da:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801031e1:	e8 d2 09 00 00       	call   80103bb8 <initlock>
}
801031e6:	c9                   	leave  
801031e7:	c3                   	ret    

801031e8 <mycpu>:
{
801031e8:	55                   	push   %ebp
801031e9:	89 e5                	mov    %esp,%ebp
801031eb:	56                   	push   %esi
801031ec:	53                   	push   %ebx
801031ed:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801031f0:	9c                   	pushf  
801031f1:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801031f2:	f6 c4 02             	test   $0x2,%ah
801031f5:	75 58                	jne    8010324f <mycpu+0x67>
  apicid = lapicid();
801031f7:	e8 64 f2 ff ff       	call   80102460 <lapicid>
  for (i = 0; i < ncpu; ++i) {
801031fc:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80103202:	85 f6                	test   %esi,%esi
80103204:	7e 3d                	jle    80103243 <mycpu+0x5b>
    if (cpus[i].apicid == apicid)
80103206:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
8010320d:	39 c2                	cmp    %eax,%edx
8010320f:	74 2e                	je     8010323f <mycpu+0x57>
80103211:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
80103216:	31 d2                	xor    %edx,%edx
80103218:	42                   	inc    %edx
80103219:	39 f2                	cmp    %esi,%edx
8010321b:	74 26                	je     80103243 <mycpu+0x5b>
    if (cpus[i].apicid == apicid)
8010321d:	0f b6 19             	movzbl (%ecx),%ebx
80103220:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103226:	39 c3                	cmp    %eax,%ebx
80103228:	75 ee                	jne    80103218 <mycpu+0x30>
      return &cpus[i];
8010322a:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010322d:	8d 04 42             	lea    (%edx,%eax,2),%eax
80103230:	c1 e0 04             	shl    $0x4,%eax
80103233:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103238:	83 c4 10             	add    $0x10,%esp
8010323b:	5b                   	pop    %ebx
8010323c:	5e                   	pop    %esi
8010323d:	5d                   	pop    %ebp
8010323e:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
8010323f:	31 d2                	xor    %edx,%edx
80103241:	eb e7                	jmp    8010322a <mycpu+0x42>
  panic("unknown apicid\n");
80103243:	c7 04 24 6c 71 10 80 	movl   $0x8010716c,(%esp)
8010324a:	e8 c1 d0 ff ff       	call   80100310 <panic>
    panic("mycpu called with interrupts enabled\n");
8010324f:	c7 04 24 48 72 10 80 	movl   $0x80107248,(%esp)
80103256:	e8 b5 d0 ff ff       	call   80100310 <panic>
8010325b:	90                   	nop

8010325c <cpuid>:
cpuid() {
8010325c:	55                   	push   %ebp
8010325d:	89 e5                	mov    %esp,%ebp
8010325f:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103262:	e8 81 ff ff ff       	call   801031e8 <mycpu>
80103267:	2d 80 27 11 80       	sub    $0x80112780,%eax
8010326c:	c1 f8 04             	sar    $0x4,%eax
8010326f:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
80103272:	89 ca                	mov    %ecx,%edx
80103274:	c1 e2 05             	shl    $0x5,%edx
80103277:	29 ca                	sub    %ecx,%edx
80103279:	8d 14 90             	lea    (%eax,%edx,4),%edx
8010327c:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
8010327f:	89 ca                	mov    %ecx,%edx
80103281:	c1 e2 0f             	shl    $0xf,%edx
80103284:	29 ca                	sub    %ecx,%edx
80103286:	8d 04 90             	lea    (%eax,%edx,4),%eax
80103289:	f7 d8                	neg    %eax
}
8010328b:	c9                   	leave  
8010328c:	c3                   	ret    
8010328d:	8d 76 00             	lea    0x0(%esi),%esi

80103290 <myproc>:
myproc(void) {
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
80103293:	53                   	push   %ebx
80103294:	51                   	push   %ecx
  pushcli();
80103295:	e8 ae 09 00 00       	call   80103c48 <pushcli>
  c = mycpu();
8010329a:	e8 49 ff ff ff       	call   801031e8 <mycpu>
  p = c->proc;
8010329f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801032a5:	e8 3a 0a 00 00       	call   80103ce4 <popcli>
}
801032aa:	89 d8                	mov    %ebx,%eax
801032ac:	5b                   	pop    %ebx
801032ad:	5b                   	pop    %ebx
801032ae:	5d                   	pop    %ebp
801032af:	c3                   	ret    

801032b0 <userinit>:
  for(s = s_cand; s < &s_cand[NPROC]; s++){
801032b0:	b8 c0 57 11 80       	mov    $0x801157c0,%eax
801032b5:	8d 76 00             	lea    0x0(%esi),%esi
    s->valid = 0;
801032b8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    s->proc = 0;
801032bf:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  for(s = s_cand; s < &s_cand[NPROC]; s++){
801032c6:	83 c0 14             	add    $0x14,%eax
801032c9:	3d c0 5c 11 80       	cmp    $0x80115cc0,%eax
801032ce:	72 e8                	jb     801032b8 <userinit+0x8>
  s_cand[0].valid = 1;
801032d0:	c7 05 cc 57 11 80 01 	movl   $0x1,0x801157cc
801032d7:	00 00 00 
801032da:	31 d2                	xor    %edx,%edx
    MLFQ_table[i].total = 0;
801032dc:	c7 82 c0 5c 11 80 00 	movl   $0x0,-0x7feea340(%edx)
801032e3:	00 00 00 
    MLFQ_table[i].recent = 0;
801032e6:	c7 82 c4 5c 11 80 00 	movl   $0x0,-0x7feea33c(%edx)
801032ed:	00 00 00 
    for(j = 0; j < NPROC; j++){
801032f0:	31 c0                	xor    %eax,%eax
801032f2:	66 90                	xchg   %ax,%ax
      MLFQ_table[i].wait[j] = 0;
801032f4:	c7 84 82 c8 5c 11 80 	movl   $0x0,-0x7feea338(%edx,%eax,4)
801032fb:	00 00 00 00 
    for(j = 0; j < NPROC; j++){
801032ff:	40                   	inc    %eax
80103300:	83 f8 40             	cmp    $0x40,%eax
80103303:	75 ef                	jne    801032f4 <userinit+0x44>
80103305:	81 c2 08 01 00 00    	add    $0x108,%edx
  for(i = 0; i < 3; i++){
8010330b:	81 fa 18 03 00 00    	cmp    $0x318,%edx
80103311:	75 c9                	jne    801032dc <userinit+0x2c>
{
80103313:	55                   	push   %ebp
80103314:	89 e5                	mov    %esp,%ebp
80103316:	53                   	push   %ebx
80103317:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
8010331a:	e8 81 fd ff ff       	call   801030a0 <allocproc>
8010331f:	89 c3                	mov    %eax,%ebx
  s_cand[0].proc = p;
80103321:	a3 d0 57 11 80       	mov    %eax,0x801157d0
  initproc = p;
80103326:	a3 a0 a5 10 80       	mov    %eax,0x8010a5a0
  if((p->pgdir = setupkvm()) == 0)
8010332b:	e8 a4 2f 00 00       	call   801062d4 <setupkvm>
80103330:	89 43 04             	mov    %eax,0x4(%ebx)
80103333:	85 c0                	test   %eax,%eax
80103335:	0f 84 cc 00 00 00    	je     80103407 <userinit+0x157>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010333b:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
80103342:	00 
80103343:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
8010334a:	80 
8010334b:	89 04 24             	mov    %eax,(%esp)
8010334e:	e8 f9 2b 00 00       	call   80105f4c <inituvm>
  p->sz = PGSIZE;
80103353:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103359:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103360:	00 
80103361:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103368:	00 
80103369:	8b 43 18             	mov    0x18(%ebx),%eax
8010336c:	89 04 24             	mov    %eax,(%esp)
8010336f:	e8 10 0a 00 00       	call   80103d84 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103374:	8b 43 18             	mov    0x18(%ebx),%eax
80103377:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010337d:	8b 43 18             	mov    0x18(%ebx),%eax
80103380:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103386:	8b 43 18             	mov    0x18(%ebx),%eax
80103389:	8b 50 2c             	mov    0x2c(%eax),%edx
8010338c:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103390:	8b 43 18             	mov    0x18(%ebx),%eax
80103393:	8b 50 2c             	mov    0x2c(%eax),%edx
80103396:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010339a:	8b 43 18             	mov    0x18(%ebx),%eax
8010339d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801033a4:	8b 43 18             	mov    0x18(%ebx),%eax
801033a7:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801033ae:	8b 43 18             	mov    0x18(%ebx),%eax
801033b1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801033b8:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801033bf:	00 
801033c0:	c7 44 24 04 95 71 10 	movl   $0x80107195,0x4(%esp)
801033c7:	80 
801033c8:	8d 43 6c             	lea    0x6c(%ebx),%eax
801033cb:	89 04 24             	mov    %eax,(%esp)
801033ce:	e8 49 0b 00 00       	call   80103f1c <safestrcpy>
  p->cwd = namei("/");
801033d3:	c7 04 24 9e 71 10 80 	movl   $0x8010719e,(%esp)
801033da:	e8 49 e9 ff ff       	call   80101d28 <namei>
801033df:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801033e2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801033e9:	e8 92 08 00 00       	call   80103c80 <acquire>
  p->state = RUNNABLE;
801033ee:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801033f5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801033fc:	e8 3b 09 00 00       	call   80103d3c <release>
}
80103401:	83 c4 14             	add    $0x14,%esp
80103404:	5b                   	pop    %ebx
80103405:	5d                   	pop    %ebp
80103406:	c3                   	ret    
    panic("userinit: out of memory?");
80103407:	c7 04 24 7c 71 10 80 	movl   $0x8010717c,(%esp)
8010340e:	e8 fd ce ff ff       	call   80100310 <panic>
80103413:	90                   	nop

80103414 <growproc>:
{
80103414:	55                   	push   %ebp
80103415:	89 e5                	mov    %esp,%ebp
80103417:	53                   	push   %ebx
80103418:	83 ec 14             	sub    $0x14,%esp
  struct proc *curproc = myproc();
8010341b:	e8 70 fe ff ff       	call   80103290 <myproc>
80103420:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103422:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103424:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80103428:	7e 2e                	jle    80103458 <growproc+0x44>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010342a:	8b 55 08             	mov    0x8(%ebp),%edx
8010342d:	01 c2                	add    %eax,%edx
8010342f:	89 54 24 08          	mov    %edx,0x8(%esp)
80103433:	89 44 24 04          	mov    %eax,0x4(%esp)
80103437:	8b 43 04             	mov    0x4(%ebx),%eax
8010343a:	89 04 24             	mov    %eax,(%esp)
8010343d:	e8 ee 2c 00 00       	call   80106130 <allocuvm>
80103442:	85 c0                	test   %eax,%eax
80103444:	74 32                	je     80103478 <growproc+0x64>
  curproc->sz = sz;
80103446:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103448:	89 1c 24             	mov    %ebx,(%esp)
8010344b:	e8 00 2a 00 00       	call   80105e50 <switchuvm>
  return 0;
80103450:	31 c0                	xor    %eax,%eax
}
80103452:	83 c4 14             	add    $0x14,%esp
80103455:	5b                   	pop    %ebx
80103456:	5d                   	pop    %ebp
80103457:	c3                   	ret    
  } else if(n < 0){
80103458:	74 ec                	je     80103446 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010345a:	8b 55 08             	mov    0x8(%ebp),%edx
8010345d:	01 c2                	add    %eax,%edx
8010345f:	89 54 24 08          	mov    %edx,0x8(%esp)
80103463:	89 44 24 04          	mov    %eax,0x4(%esp)
80103467:	8b 43 04             	mov    0x4(%ebx),%eax
8010346a:	89 04 24             	mov    %eax,(%esp)
8010346d:	e8 16 2c 00 00       	call   80106088 <deallocuvm>
80103472:	85 c0                	test   %eax,%eax
80103474:	75 d0                	jne    80103446 <growproc+0x32>
80103476:	66 90                	xchg   %ax,%ax
      return -1;
80103478:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010347d:	eb d3                	jmp    80103452 <growproc+0x3e>
8010347f:	90                   	nop

80103480 <fork>:
{
80103480:	55                   	push   %ebp
80103481:	89 e5                	mov    %esp,%ebp
80103483:	57                   	push   %edi
80103484:	56                   	push   %esi
80103485:	53                   	push   %ebx
80103486:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *curproc = myproc();
80103489:	e8 02 fe ff ff       	call   80103290 <myproc>
8010348e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103490:	e8 0b fc ff ff       	call   801030a0 <allocproc>
80103495:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103498:	85 c0                	test   %eax,%eax
8010349a:	0f 84 c4 00 00 00    	je     80103564 <fork+0xe4>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801034a0:	8b 03                	mov    (%ebx),%eax
801034a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801034a6:	8b 43 04             	mov    0x4(%ebx),%eax
801034a9:	89 04 24             	mov    %eax,(%esp)
801034ac:	e8 df 2e 00 00       	call   80106390 <copyuvm>
801034b1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801034b4:	89 42 04             	mov    %eax,0x4(%edx)
801034b7:	85 c0                	test   %eax,%eax
801034b9:	0f 84 ac 00 00 00    	je     8010356b <fork+0xeb>
  np->sz = curproc->sz;
801034bf:	8b 03                	mov    (%ebx),%eax
801034c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801034c4:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
801034c6:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
801034c9:	8b 42 18             	mov    0x18(%edx),%eax
801034cc:	89 45 e0             	mov    %eax,-0x20(%ebp)
801034cf:	8b 73 18             	mov    0x18(%ebx),%esi
801034d2:	b9 13 00 00 00       	mov    $0x13,%ecx
801034d7:	89 c7                	mov    %eax,%edi
801034d9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
801034db:	8b 42 18             	mov    0x18(%edx),%eax
801034de:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
801034e5:	31 f6                	xor    %esi,%esi
801034e7:	90                   	nop
    if(curproc->ofile[i])
801034e8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801034ec:	85 c0                	test   %eax,%eax
801034ee:	74 0f                	je     801034ff <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
801034f0:	89 04 24             	mov    %eax,(%esp)
801034f3:	e8 04 d8 ff ff       	call   80100cfc <filedup>
801034f8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801034fb:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
801034ff:	46                   	inc    %esi
80103500:	83 fe 10             	cmp    $0x10,%esi
80103503:	75 e3                	jne    801034e8 <fork+0x68>
  np->cwd = idup(curproc->cwd);
80103505:	8b 43 68             	mov    0x68(%ebx),%eax
80103508:	89 04 24             	mov    %eax,(%esp)
8010350b:	e8 10 e0 ff ff       	call   80101520 <idup>
80103510:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103513:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103516:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010351d:	00 
8010351e:	83 c3 6c             	add    $0x6c,%ebx
80103521:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103525:	89 d0                	mov    %edx,%eax
80103527:	83 c0 6c             	add    $0x6c,%eax
8010352a:	89 04 24             	mov    %eax,(%esp)
8010352d:	e8 ea 09 00 00       	call   80103f1c <safestrcpy>
  pid = np->pid;
80103532:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103535:	8b 58 10             	mov    0x10(%eax),%ebx
  acquire(&ptable.lock);
80103538:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010353f:	e8 3c 07 00 00       	call   80103c80 <acquire>
  np->state = RUNNABLE;
80103544:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103547:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
8010354e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103555:	e8 e2 07 00 00       	call   80103d3c <release>
}
8010355a:	89 d8                	mov    %ebx,%eax
8010355c:	83 c4 2c             	add    $0x2c,%esp
8010355f:	5b                   	pop    %ebx
80103560:	5e                   	pop    %esi
80103561:	5f                   	pop    %edi
80103562:	5d                   	pop    %ebp
80103563:	c3                   	ret    
    return -1;
80103564:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103569:	eb ef                	jmp    8010355a <fork+0xda>
    kfree(np->kstack);
8010356b:	8b 42 08             	mov    0x8(%edx),%eax
8010356e:	89 04 24             	mov    %eax,(%esp)
80103571:	e8 3a eb ff ff       	call   801020b0 <kfree>
    np->kstack = 0;
80103576:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103579:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80103580:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80103587:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010358c:	eb cc                	jmp    8010355a <fork+0xda>
8010358e:	66 90                	xchg   %ax,%ax

80103590 <sched>:
{
80103590:	55                   	push   %ebp
80103591:	89 e5                	mov    %esp,%ebp
80103593:	56                   	push   %esi
80103594:	53                   	push   %ebx
80103595:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
80103598:	e8 f3 fc ff ff       	call   80103290 <myproc>
8010359d:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
8010359f:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035a6:	e8 75 06 00 00       	call   80103c20 <holding>
801035ab:	85 c0                	test   %eax,%eax
801035ad:	74 4f                	je     801035fe <sched+0x6e>
  if(mycpu()->ncli != 1)
801035af:	e8 34 fc ff ff       	call   801031e8 <mycpu>
801035b4:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801035bb:	75 65                	jne    80103622 <sched+0x92>
  if(p->state == RUNNING)
801035bd:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801035c1:	74 53                	je     80103616 <sched+0x86>
801035c3:	9c                   	pushf  
801035c4:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801035c5:	f6 c4 02             	test   $0x2,%ah
801035c8:	75 40                	jne    8010360a <sched+0x7a>
  intena = mycpu()->intena;
801035ca:	e8 19 fc ff ff       	call   801031e8 <mycpu>
801035cf:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801035d5:	e8 0e fc ff ff       	call   801031e8 <mycpu>
801035da:	8b 40 04             	mov    0x4(%eax),%eax
801035dd:	89 44 24 04          	mov    %eax,0x4(%esp)
801035e1:	83 c3 1c             	add    $0x1c,%ebx
801035e4:	89 1c 24             	mov    %ebx,(%esp)
801035e7:	e8 79 09 00 00       	call   80103f65 <swtch>
  mycpu()->intena = intena;
801035ec:	e8 f7 fb ff ff       	call   801031e8 <mycpu>
801035f1:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801035f7:	83 c4 10             	add    $0x10,%esp
801035fa:	5b                   	pop    %ebx
801035fb:	5e                   	pop    %esi
801035fc:	5d                   	pop    %ebp
801035fd:	c3                   	ret    
    panic("sched ptable.lock");
801035fe:	c7 04 24 a0 71 10 80 	movl   $0x801071a0,(%esp)
80103605:	e8 06 cd ff ff       	call   80100310 <panic>
    panic("sched interruptible");
8010360a:	c7 04 24 cc 71 10 80 	movl   $0x801071cc,(%esp)
80103611:	e8 fa cc ff ff       	call   80100310 <panic>
    panic("sched running");
80103616:	c7 04 24 be 71 10 80 	movl   $0x801071be,(%esp)
8010361d:	e8 ee cc ff ff       	call   80100310 <panic>
    panic("sched locks");
80103622:	c7 04 24 b2 71 10 80 	movl   $0x801071b2,(%esp)
80103629:	e8 e2 cc ff ff       	call   80100310 <panic>
8010362e:	66 90                	xchg   %ax,%ax

80103630 <exit>:
{
80103630:	55                   	push   %ebp
80103631:	89 e5                	mov    %esp,%ebp
80103633:	56                   	push   %esi
80103634:	53                   	push   %ebx
80103635:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103638:	e8 53 fc ff ff       	call   80103290 <myproc>
8010363d:	89 c3                	mov    %eax,%ebx
  if(curproc == initproc)
8010363f:	31 f6                	xor    %esi,%esi
80103641:	3b 05 a0 a5 10 80    	cmp    0x8010a5a0,%eax
80103647:	0f 84 23 01 00 00    	je     80103770 <exit+0x140>
8010364d:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80103650:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103654:	85 c0                	test   %eax,%eax
80103656:	74 10                	je     80103668 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103658:	89 04 24             	mov    %eax,(%esp)
8010365b:	e8 e0 d6 ff ff       	call   80100d40 <fileclose>
      curproc->ofile[fd] = 0;
80103660:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103667:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103668:	46                   	inc    %esi
80103669:	83 fe 10             	cmp    $0x10,%esi
8010366c:	75 e2                	jne    80103650 <exit+0x20>
  begin_op();
8010366e:	e8 25 f1 ff ff       	call   80102798 <begin_op>
  iput(curproc->cwd);
80103673:	8b 43 68             	mov    0x68(%ebx),%eax
80103676:	89 04 24             	mov    %eax,(%esp)
80103679:	e8 e2 df ff ff       	call   80101660 <iput>
  end_op();
8010367e:	e8 71 f1 ff ff       	call   801027f4 <end_op>
  curproc->cwd = 0;
80103683:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
8010368a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103691:	e8 ea 05 00 00       	call   80103c80 <acquire>
  wakeup1(curproc->parent);
80103696:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103699:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
8010369e:	eb 0e                	jmp    801036ae <exit+0x7e>
801036a0:	81 c2 88 00 00 00    	add    $0x88,%edx
801036a6:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
801036ac:	74 20                	je     801036ce <exit+0x9e>
    if(p->state == SLEEPING && p->chan == chan)
801036ae:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
801036b2:	75 ec                	jne    801036a0 <exit+0x70>
801036b4:	3b 42 20             	cmp    0x20(%edx),%eax
801036b7:	75 e7                	jne    801036a0 <exit+0x70>
      p->state = RUNNABLE;
801036b9:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036c0:	81 c2 88 00 00 00    	add    $0x88,%edx
801036c6:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
801036cc:	75 e0                	jne    801036ae <exit+0x7e>
      p->parent = initproc;
801036ce:	a1 a0 a5 10 80       	mov    0x8010a5a0,%eax
801036d3:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
801036d8:	eb 10                	jmp    801036ea <exit+0xba>
801036da:	66 90                	xchg   %ax,%ax
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801036dc:	81 c1 88 00 00 00    	add    $0x88,%ecx
801036e2:	81 f9 54 4f 11 80    	cmp    $0x80114f54,%ecx
801036e8:	74 38                	je     80103722 <exit+0xf2>
    if(p->parent == curproc){
801036ea:	39 59 14             	cmp    %ebx,0x14(%ecx)
801036ed:	75 ed                	jne    801036dc <exit+0xac>
      p->parent = initproc;
801036ef:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
801036f2:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
801036f6:	75 e4                	jne    801036dc <exit+0xac>
801036f8:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
801036fd:	eb 0f                	jmp    8010370e <exit+0xde>
801036ff:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103700:	81 c2 88 00 00 00    	add    $0x88,%edx
80103706:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
8010370c:	74 ce                	je     801036dc <exit+0xac>
    if(p->state == SLEEPING && p->chan == chan)
8010370e:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103712:	75 ec                	jne    80103700 <exit+0xd0>
80103714:	3b 42 20             	cmp    0x20(%edx),%eax
80103717:	75 e7                	jne    80103700 <exit+0xd0>
      p->state = RUNNABLE;
80103719:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103720:	eb de                	jmp    80103700 <exit+0xd0>
  if(curproc->myst == s_cand){
80103722:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103728:	3d c0 57 11 80       	cmp    $0x801157c0,%eax
8010372d:	74 4d                	je     8010377c <exit+0x14c>
    curproc->myst->valid = 0;
8010372f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    s_cand[0].share += curproc->myst->share;
80103736:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
8010373c:	8b 0d c8 57 11 80    	mov    0x801157c8,%ecx
80103742:	03 48 08             	add    0x8(%eax),%ecx
80103745:	89 0d c8 57 11 80    	mov    %ecx,0x801157c8
    s_cand[0].stride = 10000000 / s_cand[0].share;
8010374b:	b8 80 96 98 00       	mov    $0x989680,%eax
80103750:	99                   	cltd   
80103751:	f7 f9                	idiv   %ecx
80103753:	a3 c0 57 11 80       	mov    %eax,0x801157c0
  curproc->state = ZOMBIE;
80103758:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010375f:	e8 2c fe ff ff       	call   80103590 <sched>
  panic("zombie exit");
80103764:	c7 04 24 ed 71 10 80 	movl   $0x801071ed,(%esp)
8010376b:	e8 a0 cb ff ff       	call   80100310 <panic>
    panic("init exiting");
80103770:	c7 04 24 e0 71 10 80 	movl   $0x801071e0,(%esp)
80103777:	e8 94 cb ff ff       	call   80100310 <panic>
    pop_MLFQ(curproc);
8010377c:	89 1c 24             	mov    %ebx,(%esp)
8010377f:	e8 78 2e 00 00       	call   801065fc <pop_MLFQ>
80103784:	eb d2                	jmp    80103758 <exit+0x128>
80103786:	66 90                	xchg   %ax,%ax

80103788 <yield>:
{
80103788:	55                   	push   %ebp
80103789:	89 e5                	mov    %esp,%ebp
8010378b:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
8010378e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103795:	e8 e6 04 00 00       	call   80103c80 <acquire>
  myproc()->state = RUNNABLE;
8010379a:	e8 f1 fa ff ff       	call   80103290 <myproc>
8010379f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801037a6:	e8 e5 fd ff ff       	call   80103590 <sched>
  release(&ptable.lock);
801037ab:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037b2:	e8 85 05 00 00       	call   80103d3c <release>
}
801037b7:	c9                   	leave  
801037b8:	c3                   	ret    
801037b9:	8d 76 00             	lea    0x0(%esi),%esi

801037bc <sleep>:
{
801037bc:	55                   	push   %ebp
801037bd:	89 e5                	mov    %esp,%ebp
801037bf:	57                   	push   %edi
801037c0:	56                   	push   %esi
801037c1:	53                   	push   %ebx
801037c2:	83 ec 1c             	sub    $0x1c,%esp
801037c5:	8b 7d 08             	mov    0x8(%ebp),%edi
801037c8:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
801037cb:	e8 c0 fa ff ff       	call   80103290 <myproc>
801037d0:	89 c3                	mov    %eax,%ebx
  if(p == 0)
801037d2:	85 c0                	test   %eax,%eax
801037d4:	74 7c                	je     80103852 <sleep+0x96>
  if(lk == 0)
801037d6:	85 f6                	test   %esi,%esi
801037d8:	74 6c                	je     80103846 <sleep+0x8a>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801037da:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801037e0:	74 46                	je     80103828 <sleep+0x6c>
    acquire(&ptable.lock);  //DOC: sleeplock1
801037e2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037e9:	e8 92 04 00 00       	call   80103c80 <acquire>
    release(lk);
801037ee:	89 34 24             	mov    %esi,(%esp)
801037f1:	e8 46 05 00 00       	call   80103d3c <release>
  p->chan = chan;
801037f6:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801037f9:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103800:	e8 8b fd ff ff       	call   80103590 <sched>
  p->chan = 0;
80103805:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
8010380c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103813:	e8 24 05 00 00       	call   80103d3c <release>
    acquire(lk);
80103818:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010381b:	83 c4 1c             	add    $0x1c,%esp
8010381e:	5b                   	pop    %ebx
8010381f:	5e                   	pop    %esi
80103820:	5f                   	pop    %edi
80103821:	5d                   	pop    %ebp
    acquire(lk);
80103822:	e9 59 04 00 00       	jmp    80103c80 <acquire>
80103827:	90                   	nop
  p->chan = chan;
80103828:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
8010382b:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103832:	e8 59 fd ff ff       	call   80103590 <sched>
  p->chan = 0;
80103837:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010383e:	83 c4 1c             	add    $0x1c,%esp
80103841:	5b                   	pop    %ebx
80103842:	5e                   	pop    %esi
80103843:	5f                   	pop    %edi
80103844:	5d                   	pop    %ebp
80103845:	c3                   	ret    
    panic("sleep without lk");
80103846:	c7 04 24 ff 71 10 80 	movl   $0x801071ff,(%esp)
8010384d:	e8 be ca ff ff       	call   80100310 <panic>
    panic("sleep");
80103852:	c7 04 24 f9 71 10 80 	movl   $0x801071f9,(%esp)
80103859:	e8 b2 ca ff ff       	call   80100310 <panic>
8010385e:	66 90                	xchg   %ax,%ax

80103860 <wait>:
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	56                   	push   %esi
80103864:	53                   	push   %ebx
80103865:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103868:	e8 23 fa ff ff       	call   80103290 <myproc>
8010386d:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
8010386f:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103876:	e8 05 04 00 00       	call   80103c80 <acquire>
    havekids = 0;
8010387b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010387d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103882:	eb 0e                	jmp    80103892 <wait+0x32>
80103884:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010388a:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103890:	74 1e                	je     801038b0 <wait+0x50>
      if(p->parent != curproc)
80103892:	39 73 14             	cmp    %esi,0x14(%ebx)
80103895:	75 ed                	jne    80103884 <wait+0x24>
      if(p->state == ZOMBIE){
80103897:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010389b:	74 30                	je     801038cd <wait+0x6d>
      havekids = 1;
8010389d:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038a2:	81 c3 88 00 00 00    	add    $0x88,%ebx
801038a8:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
801038ae:	75 e2                	jne    80103892 <wait+0x32>
    if(!havekids || curproc->killed){
801038b0:	85 c0                	test   %eax,%eax
801038b2:	74 6e                	je     80103922 <wait+0xc2>
801038b4:	8b 46 24             	mov    0x24(%esi),%eax
801038b7:	85 c0                	test   %eax,%eax
801038b9:	75 67                	jne    80103922 <wait+0xc2>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801038bb:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
801038c2:	80 
801038c3:	89 34 24             	mov    %esi,(%esp)
801038c6:	e8 f1 fe ff ff       	call   801037bc <sleep>
  }
801038cb:	eb ae                	jmp    8010387b <wait+0x1b>
        pid = p->pid;
801038cd:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801038d0:	8b 43 08             	mov    0x8(%ebx),%eax
801038d3:	89 04 24             	mov    %eax,(%esp)
801038d6:	e8 d5 e7 ff ff       	call   801020b0 <kfree>
        p->kstack = 0;
801038db:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801038e2:	8b 43 04             	mov    0x4(%ebx),%eax
801038e5:	89 04 24             	mov    %eax,(%esp)
801038e8:	e8 73 29 00 00       	call   80106260 <freevm>
        p->pid = 0;
801038ed:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801038f4:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801038fb:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
801038ff:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103906:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010390d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103914:	e8 23 04 00 00       	call   80103d3c <release>
}
80103919:	89 f0                	mov    %esi,%eax
8010391b:	83 c4 10             	add    $0x10,%esp
8010391e:	5b                   	pop    %ebx
8010391f:	5e                   	pop    %esi
80103920:	5d                   	pop    %ebp
80103921:	c3                   	ret    
      release(&ptable.lock);
80103922:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103929:	e8 0e 04 00 00       	call   80103d3c <release>
      return -1;
8010392e:	be ff ff ff ff       	mov    $0xffffffff,%esi
}
80103933:	89 f0                	mov    %esi,%eax
80103935:	83 c4 10             	add    $0x10,%esp
80103938:	5b                   	pop    %ebx
80103939:	5e                   	pop    %esi
8010393a:	5d                   	pop    %ebp
8010393b:	c3                   	ret    

8010393c <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010393c:	55                   	push   %ebp
8010393d:	89 e5                	mov    %esp,%ebp
8010393f:	53                   	push   %ebx
80103940:	83 ec 14             	sub    $0x14,%esp
80103943:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103946:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010394d:	e8 2e 03 00 00       	call   80103c80 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103952:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103957:	eb 0f                	jmp    80103968 <wakeup+0x2c>
80103959:	8d 76 00             	lea    0x0(%esi),%esi
8010395c:	05 88 00 00 00       	add    $0x88,%eax
80103961:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103966:	74 20                	je     80103988 <wakeup+0x4c>
    if(p->state == SLEEPING && p->chan == chan)
80103968:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010396c:	75 ee                	jne    8010395c <wakeup+0x20>
8010396e:	3b 58 20             	cmp    0x20(%eax),%ebx
80103971:	75 e9                	jne    8010395c <wakeup+0x20>
      p->state = RUNNABLE;
80103973:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010397a:	05 88 00 00 00       	add    $0x88,%eax
8010397f:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
80103984:	75 e2                	jne    80103968 <wakeup+0x2c>
80103986:	66 90                	xchg   %ax,%ax
  wakeup1(chan);
  release(&ptable.lock);
80103988:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
8010398f:	83 c4 14             	add    $0x14,%esp
80103992:	5b                   	pop    %ebx
80103993:	5d                   	pop    %ebp
  release(&ptable.lock);
80103994:	e9 a3 03 00 00       	jmp    80103d3c <release>
80103999:	8d 76 00             	lea    0x0(%esi),%esi

8010399c <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
8010399c:	55                   	push   %ebp
8010399d:	89 e5                	mov    %esp,%ebp
8010399f:	53                   	push   %ebx
801039a0:	83 ec 14             	sub    $0x14,%esp
801039a3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801039a6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039ad:	e8 ce 02 00 00       	call   80103c80 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039b2:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801039b7:	eb 0f                	jmp    801039c8 <kill+0x2c>
801039b9:	8d 76 00             	lea    0x0(%esi),%esi
801039bc:	05 88 00 00 00       	add    $0x88,%eax
801039c1:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
801039c6:	74 34                	je     801039fc <kill+0x60>
    if(p->pid == pid){
801039c8:	39 58 10             	cmp    %ebx,0x10(%eax)
801039cb:	75 ef                	jne    801039bc <kill+0x20>
      p->killed = 1;
801039cd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801039d4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801039d8:	74 16                	je     801039f0 <kill+0x54>
        p->state = RUNNABLE;
      release(&ptable.lock);
801039da:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039e1:	e8 56 03 00 00       	call   80103d3c <release>
      return 0;
801039e6:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801039e8:	83 c4 14             	add    $0x14,%esp
801039eb:	5b                   	pop    %ebx
801039ec:	5d                   	pop    %ebp
801039ed:	c3                   	ret    
801039ee:	66 90                	xchg   %ax,%ax
        p->state = RUNNABLE;
801039f0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801039f7:	eb e1                	jmp    801039da <kill+0x3e>
801039f9:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
801039fc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a03:	e8 34 03 00 00       	call   80103d3c <release>
  return -1;
80103a08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103a0d:	83 c4 14             	add    $0x14,%esp
80103a10:	5b                   	pop    %ebx
80103a11:	5d                   	pop    %ebp
80103a12:	c3                   	ret    
80103a13:	90                   	nop

80103a14 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103a14:	55                   	push   %ebp
80103a15:	89 e5                	mov    %esp,%ebp
80103a17:	57                   	push   %edi
80103a18:	56                   	push   %esi
80103a19:	53                   	push   %ebx
80103a1a:	83 ec 4c             	sub    $0x4c,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a1d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
procdump(void)
80103a22:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103a25:	eb 4a                	jmp    80103a71 <procdump+0x5d>
80103a27:	90                   	nop
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103a28:	8b 04 85 70 72 10 80 	mov    -0x7fef8d90(,%eax,4),%eax
80103a2f:	85 c0                	test   %eax,%eax
80103a31:	74 4a                	je     80103a7d <procdump+0x69>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
80103a33:	8d 53 6c             	lea    0x6c(%ebx),%edx
80103a36:	89 54 24 0c          	mov    %edx,0xc(%esp)
80103a3a:	89 44 24 08          	mov    %eax,0x8(%esp)
80103a3e:	8b 43 10             	mov    0x10(%ebx),%eax
80103a41:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a45:	c7 04 24 14 72 10 80 	movl   $0x80107214,(%esp)
80103a4c:	e8 63 cb ff ff       	call   801005b4 <cprintf>
    
    if(p->state == SLEEPING){
80103a51:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103a55:	74 2d                	je     80103a84 <procdump+0x70>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103a57:	c7 04 24 8b 75 10 80 	movl   $0x8010758b,(%esp)
80103a5e:	e8 51 cb ff ff       	call   801005b4 <cprintf>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a63:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103a69:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103a6f:	74 4f                	je     80103ac0 <procdump+0xac>
    if(p->state == UNUSED)
80103a71:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a74:	85 c0                	test   %eax,%eax
80103a76:	74 eb                	je     80103a63 <procdump+0x4f>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103a78:	83 f8 05             	cmp    $0x5,%eax
80103a7b:	76 ab                	jbe    80103a28 <procdump+0x14>
      state = "???";
80103a7d:	b8 10 72 10 80       	mov    $0x80107210,%eax
80103a82:	eb af                	jmp    80103a33 <procdump+0x1f>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103a84:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a8b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a8e:	8b 40 0c             	mov    0xc(%eax),%eax
80103a91:	83 c0 08             	add    $0x8,%eax
80103a94:	89 04 24             	mov    %eax,(%esp)
80103a97:	e8 38 01 00 00       	call   80103bd4 <getcallerpcs>
80103a9c:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103a9f:	90                   	nop
      for(i=0; i<10 && pc[i] != 0; i++)
80103aa0:	8b 17                	mov    (%edi),%edx
80103aa2:	85 d2                	test   %edx,%edx
80103aa4:	74 b1                	je     80103a57 <procdump+0x43>
        cprintf(" %p", pc[i]);
80103aa6:	89 54 24 04          	mov    %edx,0x4(%esp)
80103aaa:	c7 04 24 61 6c 10 80 	movl   $0x80106c61,(%esp)
80103ab1:	e8 fe ca ff ff       	call   801005b4 <cprintf>
80103ab6:	83 c7 04             	add    $0x4,%edi
      for(i=0; i<10 && pc[i] != 0; i++)
80103ab9:	39 f7                	cmp    %esi,%edi
80103abb:	75 e3                	jne    80103aa0 <procdump+0x8c>
80103abd:	eb 98                	jmp    80103a57 <procdump+0x43>
80103abf:	90                   	nop
  }
}
80103ac0:	83 c4 4c             	add    $0x4c,%esp
80103ac3:	5b                   	pop    %ebx
80103ac4:	5e                   	pop    %esi
80103ac5:	5f                   	pop    %edi
80103ac6:	5d                   	pop    %ebp
80103ac7:	c3                   	ret    

80103ac8 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103ac8:	55                   	push   %ebp
80103ac9:	89 e5                	mov    %esp,%ebp
80103acb:	53                   	push   %ebx
80103acc:	83 ec 14             	sub    $0x14,%esp
80103acf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103ad2:	c7 44 24 04 88 72 10 	movl   $0x80107288,0x4(%esp)
80103ad9:	80 
80103ada:	8d 43 04             	lea    0x4(%ebx),%eax
80103add:	89 04 24             	mov    %eax,(%esp)
80103ae0:	e8 d3 00 00 00       	call   80103bb8 <initlock>
  lk->name = name;
80103ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103ae8:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103aeb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103af1:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103af8:	83 c4 14             	add    $0x14,%esp
80103afb:	5b                   	pop    %ebx
80103afc:	5d                   	pop    %ebp
80103afd:	c3                   	ret    
80103afe:	66 90                	xchg   %ax,%ax

80103b00 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	56                   	push   %esi
80103b04:	53                   	push   %ebx
80103b05:	83 ec 10             	sub    $0x10,%esp
80103b08:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103b0b:	8d 73 04             	lea    0x4(%ebx),%esi
80103b0e:	89 34 24             	mov    %esi,(%esp)
80103b11:	e8 6a 01 00 00       	call   80103c80 <acquire>
  while (lk->locked) {
80103b16:	8b 13                	mov    (%ebx),%edx
80103b18:	85 d2                	test   %edx,%edx
80103b1a:	74 12                	je     80103b2e <acquiresleep+0x2e>
    sleep(lk, &lk->lk);
80103b1c:	89 74 24 04          	mov    %esi,0x4(%esp)
80103b20:	89 1c 24             	mov    %ebx,(%esp)
80103b23:	e8 94 fc ff ff       	call   801037bc <sleep>
  while (lk->locked) {
80103b28:	8b 03                	mov    (%ebx),%eax
80103b2a:	85 c0                	test   %eax,%eax
80103b2c:	75 ee                	jne    80103b1c <acquiresleep+0x1c>
  }
  lk->locked = 1;
80103b2e:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103b34:	e8 57 f7 ff ff       	call   80103290 <myproc>
80103b39:	8b 40 10             	mov    0x10(%eax),%eax
80103b3c:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103b3f:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103b42:	83 c4 10             	add    $0x10,%esp
80103b45:	5b                   	pop    %ebx
80103b46:	5e                   	pop    %esi
80103b47:	5d                   	pop    %ebp
  release(&lk->lk);
80103b48:	e9 ef 01 00 00       	jmp    80103d3c <release>
80103b4d:	8d 76 00             	lea    0x0(%esi),%esi

80103b50 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	56                   	push   %esi
80103b54:	53                   	push   %ebx
80103b55:	83 ec 10             	sub    $0x10,%esp
80103b58:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103b5b:	8d 73 04             	lea    0x4(%ebx),%esi
80103b5e:	89 34 24             	mov    %esi,(%esp)
80103b61:	e8 1a 01 00 00       	call   80103c80 <acquire>
  lk->locked = 0;
80103b66:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103b6c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103b73:	89 1c 24             	mov    %ebx,(%esp)
80103b76:	e8 c1 fd ff ff       	call   8010393c <wakeup>
  release(&lk->lk);
80103b7b:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103b7e:	83 c4 10             	add    $0x10,%esp
80103b81:	5b                   	pop    %ebx
80103b82:	5e                   	pop    %esi
80103b83:	5d                   	pop    %ebp
  release(&lk->lk);
80103b84:	e9 b3 01 00 00       	jmp    80103d3c <release>
80103b89:	8d 76 00             	lea    0x0(%esi),%esi

80103b8c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103b8c:	55                   	push   %ebp
80103b8d:	89 e5                	mov    %esp,%ebp
80103b8f:	56                   	push   %esi
80103b90:	53                   	push   %ebx
80103b91:	83 ec 10             	sub    $0x10,%esp
80103b94:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103b97:	8d 73 04             	lea    0x4(%ebx),%esi
80103b9a:	89 34 24             	mov    %esi,(%esp)
80103b9d:	e8 de 00 00 00       	call   80103c80 <acquire>
  r = lk->locked;
80103ba2:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80103ba4:	89 34 24             	mov    %esi,(%esp)
80103ba7:	e8 90 01 00 00       	call   80103d3c <release>
  return r;
}
80103bac:	89 d8                	mov    %ebx,%eax
80103bae:	83 c4 10             	add    $0x10,%esp
80103bb1:	5b                   	pop    %ebx
80103bb2:	5e                   	pop    %esi
80103bb3:	5d                   	pop    %ebp
80103bb4:	c3                   	ret    
80103bb5:	66 90                	xchg   %ax,%ax
80103bb7:	90                   	nop

80103bb8 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103bb8:	55                   	push   %ebp
80103bb9:	89 e5                	mov    %esp,%ebp
80103bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
80103bc1:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103bc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103bca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103bd1:	5d                   	pop    %ebp
80103bd2:	c3                   	ret    
80103bd3:	90                   	nop

80103bd4 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103bd4:	55                   	push   %ebp
80103bd5:	89 e5                	mov    %esp,%ebp
80103bd7:	53                   	push   %ebx
80103bd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103bdb:	8b 55 08             	mov    0x8(%ebp),%edx
80103bde:	83 ea 08             	sub    $0x8,%edx
  for(i = 0; i < 10; i++){
80103be1:	31 c0                	xor    %eax,%eax
80103be3:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103be4:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103bea:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103bf0:	77 12                	ja     80103c04 <getcallerpcs+0x30>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103bf2:	8b 5a 04             	mov    0x4(%edx),%ebx
80103bf5:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103bf8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103bfa:	40                   	inc    %eax
80103bfb:	83 f8 0a             	cmp    $0xa,%eax
80103bfe:	75 e4                	jne    80103be4 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80103c00:	5b                   	pop    %ebx
80103c01:	5d                   	pop    %ebp
80103c02:	c3                   	ret    
80103c03:	90                   	nop
    pcs[i] = 0;
80103c04:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103c0b:	40                   	inc    %eax
80103c0c:	83 f8 0a             	cmp    $0xa,%eax
80103c0f:	74 ef                	je     80103c00 <getcallerpcs+0x2c>
    pcs[i] = 0;
80103c11:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103c18:	40                   	inc    %eax
80103c19:	83 f8 0a             	cmp    $0xa,%eax
80103c1c:	75 e6                	jne    80103c04 <getcallerpcs+0x30>
80103c1e:	eb e0                	jmp    80103c00 <getcallerpcs+0x2c>

80103c20 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80103c20:	55                   	push   %ebp
80103c21:	89 e5                	mov    %esp,%ebp
80103c23:	53                   	push   %ebx
80103c24:	51                   	push   %ecx
80103c25:	8b 45 08             	mov    0x8(%ebp),%eax
  return lock->locked && lock->cpu == mycpu();
80103c28:	8b 18                	mov    (%eax),%ebx
80103c2a:	85 db                	test   %ebx,%ebx
80103c2c:	75 06                	jne    80103c34 <holding+0x14>
80103c2e:	31 c0                	xor    %eax,%eax
}
80103c30:	5a                   	pop    %edx
80103c31:	5b                   	pop    %ebx
80103c32:	5d                   	pop    %ebp
80103c33:	c3                   	ret    
  return lock->locked && lock->cpu == mycpu();
80103c34:	8b 58 08             	mov    0x8(%eax),%ebx
80103c37:	e8 ac f5 ff ff       	call   801031e8 <mycpu>
80103c3c:	39 c3                	cmp    %eax,%ebx
80103c3e:	0f 94 c0             	sete   %al
80103c41:	0f b6 c0             	movzbl %al,%eax
}
80103c44:	5a                   	pop    %edx
80103c45:	5b                   	pop    %ebx
80103c46:	5d                   	pop    %ebp
80103c47:	c3                   	ret    

80103c48 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103c48:	55                   	push   %ebp
80103c49:	89 e5                	mov    %esp,%ebp
80103c4b:	53                   	push   %ebx
80103c4c:	50                   	push   %eax
80103c4d:	9c                   	pushf  
80103c4e:	5b                   	pop    %ebx
  asm volatile("cli");
80103c4f:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103c50:	e8 93 f5 ff ff       	call   801031e8 <mycpu>
80103c55:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80103c5b:	85 c0                	test   %eax,%eax
80103c5d:	75 11                	jne    80103c70 <pushcli+0x28>
    mycpu()->intena = eflags & FL_IF;
80103c5f:	e8 84 f5 ff ff       	call   801031e8 <mycpu>
80103c64:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103c6a:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80103c70:	e8 73 f5 ff ff       	call   801031e8 <mycpu>
80103c75:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80103c7b:	58                   	pop    %eax
80103c7c:	5b                   	pop    %ebx
80103c7d:	5d                   	pop    %ebp
80103c7e:	c3                   	ret    
80103c7f:	90                   	nop

80103c80 <acquire>:
{
80103c80:	55                   	push   %ebp
80103c81:	89 e5                	mov    %esp,%ebp
80103c83:	53                   	push   %ebx
80103c84:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103c87:	e8 bc ff ff ff       	call   80103c48 <pushcli>
  if(holding(lk))
80103c8c:	8b 45 08             	mov    0x8(%ebp),%eax
80103c8f:	89 04 24             	mov    %eax,(%esp)
80103c92:	e8 89 ff ff ff       	call   80103c20 <holding>
80103c97:	85 c0                	test   %eax,%eax
80103c99:	75 3c                	jne    80103cd7 <acquire+0x57>
  asm volatile("lock; xchgl %0, %1" :
80103c9b:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
80103ca0:	8b 55 08             	mov    0x8(%ebp),%edx
80103ca3:	89 c8                	mov    %ecx,%eax
80103ca5:	f0 87 02             	lock xchg %eax,(%edx)
80103ca8:	85 c0                	test   %eax,%eax
80103caa:	75 f4                	jne    80103ca0 <acquire+0x20>
  __sync_synchronize();
80103cac:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103cb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103cb4:	e8 2f f5 ff ff       	call   801031e8 <mycpu>
80103cb9:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103cbc:	8b 45 08             	mov    0x8(%ebp),%eax
80103cbf:	83 c0 0c             	add    $0xc,%eax
80103cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
80103cc6:	8d 45 08             	lea    0x8(%ebp),%eax
80103cc9:	89 04 24             	mov    %eax,(%esp)
80103ccc:	e8 03 ff ff ff       	call   80103bd4 <getcallerpcs>
}
80103cd1:	83 c4 14             	add    $0x14,%esp
80103cd4:	5b                   	pop    %ebx
80103cd5:	5d                   	pop    %ebp
80103cd6:	c3                   	ret    
    panic("acquire");
80103cd7:	c7 04 24 93 72 10 80 	movl   $0x80107293,(%esp)
80103cde:	e8 2d c6 ff ff       	call   80100310 <panic>
80103ce3:	90                   	nop

80103ce4 <popcli>:

void
popcli(void)
{
80103ce4:	55                   	push   %ebp
80103ce5:	89 e5                	mov    %esp,%ebp
80103ce7:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103cea:	9c                   	pushf  
80103ceb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103cec:	f6 c4 02             	test   $0x2,%ah
80103cef:	75 3d                	jne    80103d2e <popcli+0x4a>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103cf1:	e8 f2 f4 ff ff       	call   801031e8 <mycpu>
80103cf6:	ff 88 a4 00 00 00    	decl   0xa4(%eax)
80103cfc:	78 24                	js     80103d22 <popcli+0x3e>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103cfe:	e8 e5 f4 ff ff       	call   801031e8 <mycpu>
80103d03:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80103d09:	85 c0                	test   %eax,%eax
80103d0b:	74 03                	je     80103d10 <popcli+0x2c>
    sti();
}
80103d0d:	c9                   	leave  
80103d0e:	c3                   	ret    
80103d0f:	90                   	nop
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103d10:	e8 d3 f4 ff ff       	call   801031e8 <mycpu>
80103d15:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103d1b:	85 c0                	test   %eax,%eax
80103d1d:	74 ee                	je     80103d0d <popcli+0x29>
  asm volatile("sti");
80103d1f:	fb                   	sti    
}
80103d20:	c9                   	leave  
80103d21:	c3                   	ret    
    panic("popcli");
80103d22:	c7 04 24 b2 72 10 80 	movl   $0x801072b2,(%esp)
80103d29:	e8 e2 c5 ff ff       	call   80100310 <panic>
    panic("popcli - interruptible");
80103d2e:	c7 04 24 9b 72 10 80 	movl   $0x8010729b,(%esp)
80103d35:	e8 d6 c5 ff ff       	call   80100310 <panic>
80103d3a:	66 90                	xchg   %ax,%ax

80103d3c <release>:
{
80103d3c:	55                   	push   %ebp
80103d3d:	89 e5                	mov    %esp,%ebp
80103d3f:	53                   	push   %ebx
80103d40:	83 ec 14             	sub    $0x14,%esp
80103d43:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103d46:	89 1c 24             	mov    %ebx,(%esp)
80103d49:	e8 d2 fe ff ff       	call   80103c20 <holding>
80103d4e:	85 c0                	test   %eax,%eax
80103d50:	74 23                	je     80103d75 <release+0x39>
  lk->pcs[0] = 0;
80103d52:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103d59:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103d60:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103d65:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80103d6b:	83 c4 14             	add    $0x14,%esp
80103d6e:	5b                   	pop    %ebx
80103d6f:	5d                   	pop    %ebp
  popcli();
80103d70:	e9 6f ff ff ff       	jmp    80103ce4 <popcli>
    panic("release");
80103d75:	c7 04 24 b9 72 10 80 	movl   $0x801072b9,(%esp)
80103d7c:	e8 8f c5 ff ff       	call   80100310 <panic>
80103d81:	66 90                	xchg   %ax,%ax
80103d83:	90                   	nop

80103d84 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103d84:	55                   	push   %ebp
80103d85:	89 e5                	mov    %esp,%ebp
80103d87:	57                   	push   %edi
80103d88:	53                   	push   %ebx
80103d89:	8b 55 08             	mov    0x8(%ebp),%edx
  if ((int)dst%4 == 0 && n%4 == 0){
80103d8c:	f6 c2 03             	test   $0x3,%dl
80103d8f:	75 06                	jne    80103d97 <memset+0x13>
80103d91:	f6 45 10 03          	testb  $0x3,0x10(%ebp)
80103d95:	74 11                	je     80103da8 <memset+0x24>
  asm volatile("cld; rep stosb" :
80103d97:	89 d7                	mov    %edx,%edi
80103d99:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d9f:	fc                   	cld    
80103da0:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80103da2:	89 d0                	mov    %edx,%eax
80103da4:	5b                   	pop    %ebx
80103da5:	5f                   	pop    %edi
80103da6:	5d                   	pop    %ebp
80103da7:	c3                   	ret    
    c &= 0xFF;
80103da8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103dac:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103daf:	c1 e9 02             	shr    $0x2,%ecx
80103db2:	89 f8                	mov    %edi,%eax
80103db4:	c1 e0 18             	shl    $0x18,%eax
80103db7:	89 fb                	mov    %edi,%ebx
80103db9:	c1 e3 10             	shl    $0x10,%ebx
80103dbc:	09 d8                	or     %ebx,%eax
80103dbe:	09 f8                	or     %edi,%eax
80103dc0:	c1 e7 08             	shl    $0x8,%edi
80103dc3:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103dc5:	89 d7                	mov    %edx,%edi
80103dc7:	fc                   	cld    
80103dc8:	f3 ab                	rep stos %eax,%es:(%edi)
}
80103dca:	89 d0                	mov    %edx,%eax
80103dcc:	5b                   	pop    %ebx
80103dcd:	5f                   	pop    %edi
80103dce:	5d                   	pop    %ebp
80103dcf:	c3                   	ret    

80103dd0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	57                   	push   %edi
80103dd4:	56                   	push   %esi
80103dd5:	53                   	push   %ebx
80103dd6:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103dd9:	8b 75 0c             	mov    0xc(%ebp),%esi
80103ddc:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103ddf:	8d 78 ff             	lea    -0x1(%eax),%edi
80103de2:	85 c0                	test   %eax,%eax
80103de4:	74 20                	je     80103e06 <memcmp+0x36>
    if(*s1 != *s2)
80103de6:	0f b6 03             	movzbl (%ebx),%eax
80103de9:	0f b6 0e             	movzbl (%esi),%ecx
80103dec:	38 c8                	cmp    %cl,%al
80103dee:	75 20                	jne    80103e10 <memcmp+0x40>
80103df0:	31 d2                	xor    %edx,%edx
80103df2:	eb 0e                	jmp    80103e02 <memcmp+0x32>
80103df4:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
80103df9:	42                   	inc    %edx
80103dfa:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80103dfe:	38 c8                	cmp    %cl,%al
80103e00:	75 0e                	jne    80103e10 <memcmp+0x40>
  while(n-- > 0){
80103e02:	39 d7                	cmp    %edx,%edi
80103e04:	75 ee                	jne    80103df4 <memcmp+0x24>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80103e06:	31 c0                	xor    %eax,%eax
}
80103e08:	5b                   	pop    %ebx
80103e09:	5e                   	pop    %esi
80103e0a:	5f                   	pop    %edi
80103e0b:	5d                   	pop    %ebp
80103e0c:	c3                   	ret    
80103e0d:	8d 76 00             	lea    0x0(%esi),%esi
      return *s1 - *s2;
80103e10:	29 c8                	sub    %ecx,%eax
}
80103e12:	5b                   	pop    %ebx
80103e13:	5e                   	pop    %esi
80103e14:	5f                   	pop    %edi
80103e15:	5d                   	pop    %ebp
80103e16:	c3                   	ret    
80103e17:	90                   	nop

80103e18 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103e18:	55                   	push   %ebp
80103e19:	89 e5                	mov    %esp,%ebp
80103e1b:	57                   	push   %edi
80103e1c:	56                   	push   %esi
80103e1d:	53                   	push   %ebx
80103e1e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e21:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103e24:	39 c3                	cmp    %eax,%ebx
80103e26:	73 38                	jae    80103e60 <memmove+0x48>
80103e28:	8b 75 10             	mov    0x10(%ebp),%esi
80103e2b:	01 de                	add    %ebx,%esi
80103e2d:	39 f0                	cmp    %esi,%eax
80103e2f:	73 2f                	jae    80103e60 <memmove+0x48>
    s += n;
    d += n;
80103e31:	8b 7d 10             	mov    0x10(%ebp),%edi
80103e34:	01 c7                	add    %eax,%edi
    while(n-- > 0)
80103e36:	8b 55 10             	mov    0x10(%ebp),%edx
80103e39:	4a                   	dec    %edx
80103e3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103e3d:	85 c9                	test   %ecx,%ecx
80103e3f:	74 17                	je     80103e58 <memmove+0x40>
memmove(void *dst, const void *src, uint n)
80103e41:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103e44:	f7 d9                	neg    %ecx
80103e46:	8d 1c 0e             	lea    (%esi,%ecx,1),%ebx
80103e49:	01 cf                	add    %ecx,%edi
80103e4b:	90                   	nop
      *--d = *--s;
80103e4c:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
80103e4f:	88 0c 17             	mov    %cl,(%edi,%edx,1)
    while(n-- > 0)
80103e52:	4a                   	dec    %edx
80103e53:	83 fa ff             	cmp    $0xffffffff,%edx
80103e56:	75 f4                	jne    80103e4c <memmove+0x34>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80103e58:	5b                   	pop    %ebx
80103e59:	5e                   	pop    %esi
80103e5a:	5f                   	pop    %edi
80103e5b:	5d                   	pop    %ebp
80103e5c:	c3                   	ret    
80103e5d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80103e60:	31 d2                	xor    %edx,%edx
80103e62:	8b 75 10             	mov    0x10(%ebp),%esi
80103e65:	85 f6                	test   %esi,%esi
80103e67:	74 ef                	je     80103e58 <memmove+0x40>
80103e69:	8d 76 00             	lea    0x0(%esi),%esi
      *d++ = *s++;
80103e6c:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
80103e6f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80103e72:	42                   	inc    %edx
    while(n-- > 0)
80103e73:	3b 55 10             	cmp    0x10(%ebp),%edx
80103e76:	75 f4                	jne    80103e6c <memmove+0x54>
}
80103e78:	5b                   	pop    %ebx
80103e79:	5e                   	pop    %esi
80103e7a:	5f                   	pop    %edi
80103e7b:	5d                   	pop    %ebp
80103e7c:	c3                   	ret    
80103e7d:	8d 76 00             	lea    0x0(%esi),%esi

80103e80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103e80:	55                   	push   %ebp
80103e81:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80103e83:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80103e84:	eb 92                	jmp    80103e18 <memmove>
80103e86:	66 90                	xchg   %ax,%ax

80103e88 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80103e88:	55                   	push   %ebp
80103e89:	89 e5                	mov    %esp,%ebp
80103e8b:	57                   	push   %edi
80103e8c:	56                   	push   %esi
80103e8d:	53                   	push   %ebx
80103e8e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103e91:	8b 75 0c             	mov    0xc(%ebp),%esi
80103e94:	8b 7d 10             	mov    0x10(%ebp),%edi
  while(n > 0 && *p && *p == *q)
80103e97:	85 ff                	test   %edi,%edi
80103e99:	74 2d                	je     80103ec8 <strncmp+0x40>
80103e9b:	0f b6 01             	movzbl (%ecx),%eax
80103e9e:	0f b6 1e             	movzbl (%esi),%ebx
80103ea1:	84 c0                	test   %al,%al
80103ea3:	74 2f                	je     80103ed4 <strncmp+0x4c>
80103ea5:	38 d8                	cmp    %bl,%al
80103ea7:	75 2b                	jne    80103ed4 <strncmp+0x4c>
strncmp(const char *p, const char *q, uint n)
80103ea9:	8d 51 01             	lea    0x1(%ecx),%edx
80103eac:	01 cf                	add    %ecx,%edi
80103eae:	eb 11                	jmp    80103ec1 <strncmp+0x39>
  while(n > 0 && *p && *p == *q)
80103eb0:	0f b6 02             	movzbl (%edx),%eax
80103eb3:	84 c0                	test   %al,%al
80103eb5:	74 19                	je     80103ed0 <strncmp+0x48>
80103eb7:	0f b6 19             	movzbl (%ecx),%ebx
80103eba:	42                   	inc    %edx
    n--, p++, q++;
80103ebb:	89 ce                	mov    %ecx,%esi
  while(n > 0 && *p && *p == *q)
80103ebd:	38 d8                	cmp    %bl,%al
80103ebf:	75 13                	jne    80103ed4 <strncmp+0x4c>
    n--, p++, q++;
80103ec1:	8d 4e 01             	lea    0x1(%esi),%ecx
  while(n > 0 && *p && *p == *q)
80103ec4:	39 fa                	cmp    %edi,%edx
80103ec6:	75 e8                	jne    80103eb0 <strncmp+0x28>
  if(n == 0)
    return 0;
80103ec8:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80103eca:	5b                   	pop    %ebx
80103ecb:	5e                   	pop    %esi
80103ecc:	5f                   	pop    %edi
80103ecd:	5d                   	pop    %ebp
80103ece:	c3                   	ret    
80103ecf:	90                   	nop
80103ed0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80103ed4:	29 d8                	sub    %ebx,%eax
}
80103ed6:	5b                   	pop    %ebx
80103ed7:	5e                   	pop    %esi
80103ed8:	5f                   	pop    %edi
80103ed9:	5d                   	pop    %ebp
80103eda:	c3                   	ret    
80103edb:	90                   	nop

80103edc <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80103edc:	55                   	push   %ebp
80103edd:	89 e5                	mov    %esp,%ebp
80103edf:	57                   	push   %edi
80103ee0:	56                   	push   %esi
80103ee1:	53                   	push   %ebx
80103ee2:	8b 7d 08             	mov    0x8(%ebp),%edi
80103ee5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103ee8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80103eeb:	89 fa                	mov    %edi,%edx
80103eed:	eb 0b                	jmp    80103efa <strncpy+0x1e>
80103eef:	90                   	nop
80103ef0:	8a 03                	mov    (%ebx),%al
80103ef2:	88 02                	mov    %al,(%edx)
80103ef4:	42                   	inc    %edx
80103ef5:	43                   	inc    %ebx
80103ef6:	84 c0                	test   %al,%al
80103ef8:	74 08                	je     80103f02 <strncpy+0x26>
80103efa:	49                   	dec    %ecx
strncpy(char *s, const char *t, int n)
80103efb:	8d 71 01             	lea    0x1(%ecx),%esi
  while(n-- > 0 && (*s++ = *t++) != 0)
80103efe:	85 f6                	test   %esi,%esi
80103f00:	7f ee                	jg     80103ef0 <strncpy+0x14>
strncpy(char *s, const char *t, int n)
80103f02:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
    ;
  while(n-- > 0)
80103f05:	85 c9                	test   %ecx,%ecx
80103f07:	7e 0b                	jle    80103f14 <strncpy+0x38>
80103f09:	8d 76 00             	lea    0x0(%esi),%esi
    *s++ = 0;
80103f0c:	c6 02 00             	movb   $0x0,(%edx)
80103f0f:	42                   	inc    %edx
  while(n-- > 0)
80103f10:	39 c2                	cmp    %eax,%edx
80103f12:	75 f8                	jne    80103f0c <strncpy+0x30>
  return os;
}
80103f14:	89 f8                	mov    %edi,%eax
80103f16:	5b                   	pop    %ebx
80103f17:	5e                   	pop    %esi
80103f18:	5f                   	pop    %edi
80103f19:	5d                   	pop    %ebp
80103f1a:	c3                   	ret    
80103f1b:	90                   	nop

80103f1c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80103f1c:	55                   	push   %ebp
80103f1d:	89 e5                	mov    %esp,%ebp
80103f1f:	56                   	push   %esi
80103f20:	53                   	push   %ebx
80103f21:	8b 45 08             	mov    0x8(%ebp),%eax
80103f24:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103f27:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80103f2a:	85 d2                	test   %edx,%edx
80103f2c:	7e 17                	jle    80103f45 <safestrcpy+0x29>
safestrcpy(char *s, const char *t, int n)
80103f2e:	8d 74 10 ff          	lea    -0x1(%eax,%edx,1),%esi
80103f32:	89 c2                	mov    %eax,%edx
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80103f34:	39 f2                	cmp    %esi,%edx
80103f36:	74 0a                	je     80103f42 <safestrcpy+0x26>
80103f38:	8a 19                	mov    (%ecx),%bl
80103f3a:	88 1a                	mov    %bl,(%edx)
80103f3c:	42                   	inc    %edx
80103f3d:	41                   	inc    %ecx
80103f3e:	84 db                	test   %bl,%bl
80103f40:	75 f2                	jne    80103f34 <safestrcpy+0x18>
    ;
  *s = 0;
80103f42:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80103f45:	5b                   	pop    %ebx
80103f46:	5e                   	pop    %esi
80103f47:	5d                   	pop    %ebp
80103f48:	c3                   	ret    
80103f49:	8d 76 00             	lea    0x0(%esi),%esi

80103f4c <strlen>:

int
strlen(const char *s)
{
80103f4c:	55                   	push   %ebp
80103f4d:	89 e5                	mov    %esp,%ebp
80103f4f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80103f52:	31 c0                	xor    %eax,%eax
80103f54:	80 3a 00             	cmpb   $0x0,(%edx)
80103f57:	74 0a                	je     80103f63 <strlen+0x17>
80103f59:	8d 76 00             	lea    0x0(%esi),%esi
80103f5c:	40                   	inc    %eax
80103f5d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80103f61:	75 f9                	jne    80103f5c <strlen+0x10>
    ;
  return n;
}
80103f63:	5d                   	pop    %ebp
80103f64:	c3                   	ret    

80103f65 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80103f65:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80103f69:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80103f6d:	55                   	push   %ebp
  pushl %ebx
80103f6e:	53                   	push   %ebx
  pushl %esi
80103f6f:	56                   	push   %esi
  pushl %edi
80103f70:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80103f71:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80103f73:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80103f75:	5f                   	pop    %edi
  popl %esi
80103f76:	5e                   	pop    %esi
  popl %ebx
80103f77:	5b                   	pop    %ebx
  popl %ebp
80103f78:	5d                   	pop    %ebp
  ret
80103f79:	c3                   	ret    
80103f7a:	66 90                	xchg   %ax,%ax

80103f7c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80103f7c:	55                   	push   %ebp
80103f7d:	89 e5                	mov    %esp,%ebp
80103f7f:	53                   	push   %ebx
80103f80:	51                   	push   %ecx
80103f81:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80103f84:	e8 07 f3 ff ff       	call   80103290 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80103f89:	8b 00                	mov    (%eax),%eax
80103f8b:	39 d8                	cmp    %ebx,%eax
80103f8d:	76 15                	jbe    80103fa4 <fetchint+0x28>
80103f8f:	8d 53 04             	lea    0x4(%ebx),%edx
80103f92:	39 d0                	cmp    %edx,%eax
80103f94:	72 0e                	jb     80103fa4 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
80103f96:	8b 13                	mov    (%ebx),%edx
80103f98:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f9b:	89 10                	mov    %edx,(%eax)
  return 0;
80103f9d:	31 c0                	xor    %eax,%eax
}
80103f9f:	5a                   	pop    %edx
80103fa0:	5b                   	pop    %ebx
80103fa1:	5d                   	pop    %ebp
80103fa2:	c3                   	ret    
80103fa3:	90                   	nop
    return -1;
80103fa4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fa9:	eb f4                	jmp    80103f9f <fetchint+0x23>
80103fab:	90                   	nop

80103fac <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80103fac:	55                   	push   %ebp
80103fad:	89 e5                	mov    %esp,%ebp
80103faf:	53                   	push   %ebx
80103fb0:	50                   	push   %eax
80103fb1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80103fb4:	e8 d7 f2 ff ff       	call   80103290 <myproc>

  if(addr >= curproc->sz)
80103fb9:	39 18                	cmp    %ebx,(%eax)
80103fbb:	76 21                	jbe    80103fde <fetchstr+0x32>
    return -1;
  *pp = (char*)addr;
80103fbd:	89 da                	mov    %ebx,%edx
80103fbf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103fc2:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80103fc4:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80103fc6:	39 c3                	cmp    %eax,%ebx
80103fc8:	73 14                	jae    80103fde <fetchstr+0x32>
    if(*s == 0)
80103fca:	80 3b 00             	cmpb   $0x0,(%ebx)
80103fcd:	75 0a                	jne    80103fd9 <fetchstr+0x2d>
80103fcf:	eb 17                	jmp    80103fe8 <fetchstr+0x3c>
80103fd1:	8d 76 00             	lea    0x0(%esi),%esi
80103fd4:	80 3a 00             	cmpb   $0x0,(%edx)
80103fd7:	74 0f                	je     80103fe8 <fetchstr+0x3c>
  for(s = *pp; s < ep; s++){
80103fd9:	42                   	inc    %edx
80103fda:	39 d0                	cmp    %edx,%eax
80103fdc:	77 f6                	ja     80103fd4 <fetchstr+0x28>
    return -1;
80103fde:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80103fe3:	5b                   	pop    %ebx
80103fe4:	5b                   	pop    %ebx
80103fe5:	5d                   	pop    %ebp
80103fe6:	c3                   	ret    
80103fe7:	90                   	nop
      return s - *pp;
80103fe8:	89 d0                	mov    %edx,%eax
80103fea:	29 d8                	sub    %ebx,%eax
}
80103fec:	5b                   	pop    %ebx
80103fed:	5b                   	pop    %ebx
80103fee:	5d                   	pop    %ebp
80103fef:	c3                   	ret    

80103ff0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	56                   	push   %esi
80103ff4:	53                   	push   %ebx
80103ff5:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103ff8:	8b 75 0c             	mov    0xc(%ebp),%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80103ffb:	e8 90 f2 ff ff       	call   80103290 <myproc>
80104000:	89 75 0c             	mov    %esi,0xc(%ebp)
80104003:	8b 40 18             	mov    0x18(%eax),%eax
80104006:	8b 40 44             	mov    0x44(%eax),%eax
80104009:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
8010400d:	89 45 08             	mov    %eax,0x8(%ebp)
}
80104010:	5b                   	pop    %ebx
80104011:	5e                   	pop    %esi
80104012:	5d                   	pop    %ebp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104013:	e9 64 ff ff ff       	jmp    80103f7c <fetchint>

80104018 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104018:	55                   	push   %ebp
80104019:	89 e5                	mov    %esp,%ebp
8010401b:	56                   	push   %esi
8010401c:	53                   	push   %ebx
8010401d:	83 ec 20             	sub    $0x20,%esp
80104020:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104023:	e8 68 f2 ff ff       	call   80103290 <myproc>
80104028:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
8010402a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010402d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104031:	8b 45 08             	mov    0x8(%ebp),%eax
80104034:	89 04 24             	mov    %eax,(%esp)
80104037:	e8 b4 ff ff ff       	call   80103ff0 <argint>
8010403c:	85 c0                	test   %eax,%eax
8010403e:	78 24                	js     80104064 <argptr+0x4c>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104040:	85 db                	test   %ebx,%ebx
80104042:	78 20                	js     80104064 <argptr+0x4c>
80104044:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104047:	8b 06                	mov    (%esi),%eax
80104049:	39 c2                	cmp    %eax,%edx
8010404b:	73 17                	jae    80104064 <argptr+0x4c>
8010404d:	01 d3                	add    %edx,%ebx
8010404f:	39 d8                	cmp    %ebx,%eax
80104051:	72 11                	jb     80104064 <argptr+0x4c>
    return -1;
  *pp = (char*)i;
80104053:	8b 45 0c             	mov    0xc(%ebp),%eax
80104056:	89 10                	mov    %edx,(%eax)
  return 0;
80104058:	31 c0                	xor    %eax,%eax
}
8010405a:	83 c4 20             	add    $0x20,%esp
8010405d:	5b                   	pop    %ebx
8010405e:	5e                   	pop    %esi
8010405f:	5d                   	pop    %ebp
80104060:	c3                   	ret    
80104061:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104064:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104069:	83 c4 20             	add    $0x20,%esp
8010406c:	5b                   	pop    %ebx
8010406d:	5e                   	pop    %esi
8010406e:	5d                   	pop    %ebp
8010406f:	c3                   	ret    

80104070 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104076:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104079:	89 44 24 04          	mov    %eax,0x4(%esp)
8010407d:	8b 45 08             	mov    0x8(%ebp),%eax
80104080:	89 04 24             	mov    %eax,(%esp)
80104083:	e8 68 ff ff ff       	call   80103ff0 <argint>
80104088:	85 c0                	test   %eax,%eax
8010408a:	78 14                	js     801040a0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010408c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010408f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104093:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104096:	89 04 24             	mov    %eax,(%esp)
80104099:	e8 0e ff ff ff       	call   80103fac <fetchstr>
}
8010409e:	c9                   	leave  
8010409f:	c3                   	ret    
    return -1;
801040a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040a5:	c9                   	leave  
801040a6:	c3                   	ret    
801040a7:	90                   	nop

801040a8 <syscall>:
[SYS_set_cpu_share] sys_set_cpu_share,
};

void
syscall(void)
{
801040a8:	55                   	push   %ebp
801040a9:	89 e5                	mov    %esp,%ebp
801040ab:	53                   	push   %ebx
801040ac:	83 ec 24             	sub    $0x24,%esp
  int num;
  struct proc *curproc = myproc();
801040af:	e8 dc f1 ff ff       	call   80103290 <myproc>

  num = curproc->tf->eax;
801040b4:	8b 58 18             	mov    0x18(%eax),%ebx
801040b7:	8b 53 1c             	mov    0x1c(%ebx),%edx
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801040ba:	8d 4a ff             	lea    -0x1(%edx),%ecx
801040bd:	83 f9 19             	cmp    $0x19,%ecx
801040c0:	77 16                	ja     801040d8 <syscall+0x30>
801040c2:	8b 0c 95 e0 72 10 80 	mov    -0x7fef8d20(,%edx,4),%ecx
801040c9:	85 c9                	test   %ecx,%ecx
801040cb:	74 0b                	je     801040d8 <syscall+0x30>
    curproc->tf->eax = syscalls[num]();
801040cd:	ff d1                	call   *%ecx
801040cf:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801040d2:	83 c4 24             	add    $0x24,%esp
801040d5:	5b                   	pop    %ebx
801040d6:	5d                   	pop    %ebp
801040d7:	c3                   	ret    
    cprintf("%d %s: unknown sys call %d\n",
801040d8:	89 54 24 0c          	mov    %edx,0xc(%esp)
            curproc->pid, curproc->name, num);
801040dc:	8d 50 6c             	lea    0x6c(%eax),%edx
801040df:	89 54 24 08          	mov    %edx,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
801040e3:	8b 50 10             	mov    0x10(%eax),%edx
801040e6:	89 54 24 04          	mov    %edx,0x4(%esp)
801040ea:	c7 04 24 c1 72 10 80 	movl   $0x801072c1,(%esp)
801040f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
801040f4:	e8 bb c4 ff ff       	call   801005b4 <cprintf>
    curproc->tf->eax = -1;
801040f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040fc:	8b 40 18             	mov    0x18(%eax),%eax
801040ff:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104106:	83 c4 24             	add    $0x24,%esp
80104109:	5b                   	pop    %ebx
8010410a:	5d                   	pop    %ebp
8010410b:	c3                   	ret    

8010410c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010410c:	55                   	push   %ebp
8010410d:	89 e5                	mov    %esp,%ebp
8010410f:	53                   	push   %ebx
80104110:	51                   	push   %ecx
80104111:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
80104113:	e8 78 f1 ff ff       	call   80103290 <myproc>
80104118:	89 c1                	mov    %eax,%ecx

  for(fd = 0; fd < NOFILE; fd++){
8010411a:	31 c0                	xor    %eax,%eax
    if(curproc->ofile[fd] == 0){
8010411c:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
80104120:	85 d2                	test   %edx,%edx
80104122:	74 10                	je     80104134 <fdalloc+0x28>
  for(fd = 0; fd < NOFILE; fd++){
80104124:	40                   	inc    %eax
80104125:	83 f8 10             	cmp    $0x10,%eax
80104128:	75 f2                	jne    8010411c <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010412a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010412f:	5a                   	pop    %edx
80104130:	5b                   	pop    %ebx
80104131:	5d                   	pop    %ebp
80104132:	c3                   	ret    
80104133:	90                   	nop
      curproc->ofile[fd] = f;
80104134:	89 5c 81 28          	mov    %ebx,0x28(%ecx,%eax,4)
}
80104138:	5a                   	pop    %edx
80104139:	5b                   	pop    %ebx
8010413a:	5d                   	pop    %ebp
8010413b:	c3                   	ret    

8010413c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
8010413c:	55                   	push   %ebp
8010413d:	89 e5                	mov    %esp,%ebp
8010413f:	57                   	push   %edi
80104140:	56                   	push   %esi
80104141:	53                   	push   %ebx
80104142:	83 ec 4c             	sub    $0x4c,%esp
80104145:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
80104148:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010414b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010414e:	89 d6                	mov    %edx,%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104150:	8d 55 da             	lea    -0x26(%ebp),%edx
80104153:	89 54 24 04          	mov    %edx,0x4(%esp)
80104157:	89 04 24             	mov    %eax,(%esp)
8010415a:	e8 e1 db ff ff       	call   80101d40 <nameiparent>
8010415f:	89 c3                	mov    %eax,%ebx
80104161:	85 c0                	test   %eax,%eax
80104163:	0f 84 cf 00 00 00    	je     80104238 <create+0xfc>
    return 0;
  ilock(dp);
80104169:	89 04 24             	mov    %eax,(%esp)
8010416c:	e8 df d3 ff ff       	call   80101550 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104171:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104174:	89 44 24 08          	mov    %eax,0x8(%esp)
80104178:	8d 4d da             	lea    -0x26(%ebp),%ecx
8010417b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
8010417f:	89 1c 24             	mov    %ebx,(%esp)
80104182:	e8 b1 d8 ff ff       	call   80101a38 <dirlookup>
80104187:	89 c7                	mov    %eax,%edi
80104189:	85 c0                	test   %eax,%eax
8010418b:	74 3b                	je     801041c8 <create+0x8c>
    iunlockput(dp);
8010418d:	89 1c 24             	mov    %ebx,(%esp)
80104190:	e8 0b d6 ff ff       	call   801017a0 <iunlockput>
    ilock(ip);
80104195:	89 3c 24             	mov    %edi,(%esp)
80104198:	e8 b3 d3 ff ff       	call   80101550 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010419d:	66 83 fe 02          	cmp    $0x2,%si
801041a1:	75 11                	jne    801041b4 <create+0x78>
801041a3:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801041a8:	75 0a                	jne    801041b4 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801041aa:	89 f8                	mov    %edi,%eax
801041ac:	83 c4 4c             	add    $0x4c,%esp
801041af:	5b                   	pop    %ebx
801041b0:	5e                   	pop    %esi
801041b1:	5f                   	pop    %edi
801041b2:	5d                   	pop    %ebp
801041b3:	c3                   	ret    
    iunlockput(ip);
801041b4:	89 3c 24             	mov    %edi,(%esp)
801041b7:	e8 e4 d5 ff ff       	call   801017a0 <iunlockput>
    return 0;
801041bc:	31 ff                	xor    %edi,%edi
}
801041be:	89 f8                	mov    %edi,%eax
801041c0:	83 c4 4c             	add    $0x4c,%esp
801041c3:	5b                   	pop    %ebx
801041c4:	5e                   	pop    %esi
801041c5:	5f                   	pop    %edi
801041c6:	5d                   	pop    %ebp
801041c7:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
801041c8:	0f bf c6             	movswl %si,%eax
801041cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801041cf:	8b 03                	mov    (%ebx),%eax
801041d1:	89 04 24             	mov    %eax,(%esp)
801041d4:	e8 fb d1 ff ff       	call   801013d4 <ialloc>
801041d9:	89 c7                	mov    %eax,%edi
801041db:	85 c0                	test   %eax,%eax
801041dd:	0f 84 b7 00 00 00    	je     8010429a <create+0x15e>
  ilock(ip);
801041e3:	89 04 24             	mov    %eax,(%esp)
801041e6:	e8 65 d3 ff ff       	call   80101550 <ilock>
  ip->major = major;
801041eb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801041ee:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
801041f2:	8b 55 c0             	mov    -0x40(%ebp),%edx
801041f5:	66 89 57 54          	mov    %dx,0x54(%edi)
  ip->nlink = 1;
801041f9:	66 c7 47 56 01 00    	movw   $0x1,0x56(%edi)
  iupdate(ip);
801041ff:	89 3c 24             	mov    %edi,(%esp)
80104202:	e8 91 d2 ff ff       	call   80101498 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104207:	66 4e                	dec    %si
80104209:	74 35                	je     80104240 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
8010420b:	8b 47 04             	mov    0x4(%edi),%eax
8010420e:	89 44 24 08          	mov    %eax,0x8(%esp)
80104212:	8d 4d da             	lea    -0x26(%ebp),%ecx
80104215:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80104219:	89 1c 24             	mov    %ebx,(%esp)
8010421c:	e8 2f da ff ff       	call   80101c50 <dirlink>
80104221:	85 c0                	test   %eax,%eax
80104223:	78 69                	js     8010428e <create+0x152>
  iunlockput(dp);
80104225:	89 1c 24             	mov    %ebx,(%esp)
80104228:	e8 73 d5 ff ff       	call   801017a0 <iunlockput>
}
8010422d:	89 f8                	mov    %edi,%eax
8010422f:	83 c4 4c             	add    $0x4c,%esp
80104232:	5b                   	pop    %ebx
80104233:	5e                   	pop    %esi
80104234:	5f                   	pop    %edi
80104235:	5d                   	pop    %ebp
80104236:	c3                   	ret    
80104237:	90                   	nop
    return 0;
80104238:	31 ff                	xor    %edi,%edi
8010423a:	e9 6b ff ff ff       	jmp    801041aa <create+0x6e>
8010423f:	90                   	nop
    dp->nlink++;  // for ".."
80104240:	66 ff 43 56          	incw   0x56(%ebx)
    iupdate(dp);
80104244:	89 1c 24             	mov    %ebx,(%esp)
80104247:	e8 4c d2 ff ff       	call   80101498 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010424c:	8b 47 04             	mov    0x4(%edi),%eax
8010424f:	89 44 24 08          	mov    %eax,0x8(%esp)
80104253:	c7 44 24 04 68 73 10 	movl   $0x80107368,0x4(%esp)
8010425a:	80 
8010425b:	89 3c 24             	mov    %edi,(%esp)
8010425e:	e8 ed d9 ff ff       	call   80101c50 <dirlink>
80104263:	85 c0                	test   %eax,%eax
80104265:	78 1b                	js     80104282 <create+0x146>
80104267:	8b 43 04             	mov    0x4(%ebx),%eax
8010426a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010426e:	c7 44 24 04 67 73 10 	movl   $0x80107367,0x4(%esp)
80104275:	80 
80104276:	89 3c 24             	mov    %edi,(%esp)
80104279:	e8 d2 d9 ff ff       	call   80101c50 <dirlink>
8010427e:	85 c0                	test   %eax,%eax
80104280:	79 89                	jns    8010420b <create+0xcf>
      panic("create dots");
80104282:	c7 04 24 5b 73 10 80 	movl   $0x8010735b,(%esp)
80104289:	e8 82 c0 ff ff       	call   80100310 <panic>
    panic("create: dirlink");
8010428e:	c7 04 24 6a 73 10 80 	movl   $0x8010736a,(%esp)
80104295:	e8 76 c0 ff ff       	call   80100310 <panic>
    panic("create: ialloc");
8010429a:	c7 04 24 4c 73 10 80 	movl   $0x8010734c,(%esp)
801042a1:	e8 6a c0 ff ff       	call   80100310 <panic>
801042a6:	66 90                	xchg   %ax,%ax

801042a8 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801042a8:	55                   	push   %ebp
801042a9:	89 e5                	mov    %esp,%ebp
801042ab:	56                   	push   %esi
801042ac:	53                   	push   %ebx
801042ad:	83 ec 20             	sub    $0x20,%esp
801042b0:	89 c6                	mov    %eax,%esi
801042b2:	89 d3                	mov    %edx,%ebx
  if(argint(n, &fd) < 0)
801042b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801042b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801042bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801042c2:	e8 29 fd ff ff       	call   80103ff0 <argint>
801042c7:	85 c0                	test   %eax,%eax
801042c9:	78 2d                	js     801042f8 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801042cb:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801042cf:	77 27                	ja     801042f8 <argfd.constprop.0+0x50>
801042d1:	e8 ba ef ff ff       	call   80103290 <myproc>
801042d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042d9:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801042dd:	85 c0                	test   %eax,%eax
801042df:	74 17                	je     801042f8 <argfd.constprop.0+0x50>
  if(pfd)
801042e1:	85 f6                	test   %esi,%esi
801042e3:	74 02                	je     801042e7 <argfd.constprop.0+0x3f>
    *pfd = fd;
801042e5:	89 16                	mov    %edx,(%esi)
  if(pf)
801042e7:	85 db                	test   %ebx,%ebx
801042e9:	74 19                	je     80104304 <argfd.constprop.0+0x5c>
    *pf = f;
801042eb:	89 03                	mov    %eax,(%ebx)
  return 0;
801042ed:	31 c0                	xor    %eax,%eax
}
801042ef:	83 c4 20             	add    $0x20,%esp
801042f2:	5b                   	pop    %ebx
801042f3:	5e                   	pop    %esi
801042f4:	5d                   	pop    %ebp
801042f5:	c3                   	ret    
801042f6:	66 90                	xchg   %ax,%ax
    return -1;
801042f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801042fd:	83 c4 20             	add    $0x20,%esp
80104300:	5b                   	pop    %ebx
80104301:	5e                   	pop    %esi
80104302:	5d                   	pop    %ebp
80104303:	c3                   	ret    
  return 0;
80104304:	31 c0                	xor    %eax,%eax
80104306:	eb e7                	jmp    801042ef <argfd.constprop.0+0x47>

80104308 <sys_dup>:
{
80104308:	55                   	push   %ebp
80104309:	89 e5                	mov    %esp,%ebp
8010430b:	53                   	push   %ebx
8010430c:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
8010430f:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104312:	31 c0                	xor    %eax,%eax
80104314:	e8 8f ff ff ff       	call   801042a8 <argfd.constprop.0>
80104319:	85 c0                	test   %eax,%eax
8010431b:	78 23                	js     80104340 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010431d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104320:	e8 e7 fd ff ff       	call   8010410c <fdalloc>
80104325:	89 c3                	mov    %eax,%ebx
80104327:	85 c0                	test   %eax,%eax
80104329:	78 15                	js     80104340 <sys_dup+0x38>
  filedup(f);
8010432b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010432e:	89 04 24             	mov    %eax,(%esp)
80104331:	e8 c6 c9 ff ff       	call   80100cfc <filedup>
}
80104336:	89 d8                	mov    %ebx,%eax
80104338:	83 c4 24             	add    $0x24,%esp
8010433b:	5b                   	pop    %ebx
8010433c:	5d                   	pop    %ebp
8010433d:	c3                   	ret    
8010433e:	66 90                	xchg   %ax,%ax
    return -1;
80104340:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104345:	eb ef                	jmp    80104336 <sys_dup+0x2e>
80104347:	90                   	nop

80104348 <sys_read>:
{
80104348:	55                   	push   %ebp
80104349:	89 e5                	mov    %esp,%ebp
8010434b:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010434e:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104351:	31 c0                	xor    %eax,%eax
80104353:	e8 50 ff ff ff       	call   801042a8 <argfd.constprop.0>
80104358:	85 c0                	test   %eax,%eax
8010435a:	78 50                	js     801043ac <sys_read+0x64>
8010435c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010435f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104363:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010436a:	e8 81 fc ff ff       	call   80103ff0 <argint>
8010436f:	85 c0                	test   %eax,%eax
80104371:	78 39                	js     801043ac <sys_read+0x64>
80104373:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104376:	89 44 24 08          	mov    %eax,0x8(%esp)
8010437a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010437d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104381:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104388:	e8 8b fc ff ff       	call   80104018 <argptr>
8010438d:	85 c0                	test   %eax,%eax
8010438f:	78 1b                	js     801043ac <sys_read+0x64>
  return fileread(f, p, n);
80104391:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104394:	89 44 24 08          	mov    %eax,0x8(%esp)
80104398:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010439b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010439f:	8b 45 ec             	mov    -0x14(%ebp),%eax
801043a2:	89 04 24             	mov    %eax,(%esp)
801043a5:	e8 96 ca ff ff       	call   80100e40 <fileread>
}
801043aa:	c9                   	leave  
801043ab:	c3                   	ret    
    return -1;
801043ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043b1:	c9                   	leave  
801043b2:	c3                   	ret    
801043b3:	90                   	nop

801043b4 <sys_write>:
{
801043b4:	55                   	push   %ebp
801043b5:	89 e5                	mov    %esp,%ebp
801043b7:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801043ba:	8d 55 ec             	lea    -0x14(%ebp),%edx
801043bd:	31 c0                	xor    %eax,%eax
801043bf:	e8 e4 fe ff ff       	call   801042a8 <argfd.constprop.0>
801043c4:	85 c0                	test   %eax,%eax
801043c6:	78 50                	js     80104418 <sys_write+0x64>
801043c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801043cb:	89 44 24 04          	mov    %eax,0x4(%esp)
801043cf:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801043d6:	e8 15 fc ff ff       	call   80103ff0 <argint>
801043db:	85 c0                	test   %eax,%eax
801043dd:	78 39                	js     80104418 <sys_write+0x64>
801043df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043e2:	89 44 24 08          	mov    %eax,0x8(%esp)
801043e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801043e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801043ed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801043f4:	e8 1f fc ff ff       	call   80104018 <argptr>
801043f9:	85 c0                	test   %eax,%eax
801043fb:	78 1b                	js     80104418 <sys_write+0x64>
  return filewrite(f, p, n);
801043fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104400:	89 44 24 08          	mov    %eax,0x8(%esp)
80104404:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104407:	89 44 24 04          	mov    %eax,0x4(%esp)
8010440b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010440e:	89 04 24             	mov    %eax,(%esp)
80104411:	e8 be ca ff ff       	call   80100ed4 <filewrite>
}
80104416:	c9                   	leave  
80104417:	c3                   	ret    
    return -1;
80104418:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010441d:	c9                   	leave  
8010441e:	c3                   	ret    
8010441f:	90                   	nop

80104420 <sys_close>:
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
80104426:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104429:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010442c:	e8 77 fe ff ff       	call   801042a8 <argfd.constprop.0>
80104431:	85 c0                	test   %eax,%eax
80104433:	78 1f                	js     80104454 <sys_close+0x34>
  myproc()->ofile[fd] = 0;
80104435:	e8 56 ee ff ff       	call   80103290 <myproc>
8010443a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010443d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104444:	00 
  fileclose(f);
80104445:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104448:	89 04 24             	mov    %eax,(%esp)
8010444b:	e8 f0 c8 ff ff       	call   80100d40 <fileclose>
  return 0;
80104450:	31 c0                	xor    %eax,%eax
}
80104452:	c9                   	leave  
80104453:	c3                   	ret    
    return -1;
80104454:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104459:	c9                   	leave  
8010445a:	c3                   	ret    
8010445b:	90                   	nop

8010445c <sys_fstat>:
{
8010445c:	55                   	push   %ebp
8010445d:	89 e5                	mov    %esp,%ebp
8010445f:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104462:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104465:	31 c0                	xor    %eax,%eax
80104467:	e8 3c fe ff ff       	call   801042a8 <argfd.constprop.0>
8010446c:	85 c0                	test   %eax,%eax
8010446e:	78 34                	js     801044a4 <sys_fstat+0x48>
80104470:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104477:	00 
80104478:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010447b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010447f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104486:	e8 8d fb ff ff       	call   80104018 <argptr>
8010448b:	85 c0                	test   %eax,%eax
8010448d:	78 15                	js     801044a4 <sys_fstat+0x48>
  return filestat(f, st);
8010448f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104492:	89 44 24 04          	mov    %eax,0x4(%esp)
80104496:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104499:	89 04 24             	mov    %eax,(%esp)
8010449c:	e8 53 c9 ff ff       	call   80100df4 <filestat>
}
801044a1:	c9                   	leave  
801044a2:	c3                   	ret    
801044a3:	90                   	nop
    return -1;
801044a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044a9:	c9                   	leave  
801044aa:	c3                   	ret    
801044ab:	90                   	nop

801044ac <sys_link>:
{
801044ac:	55                   	push   %ebp
801044ad:	89 e5                	mov    %esp,%ebp
801044af:	57                   	push   %edi
801044b0:	56                   	push   %esi
801044b1:	53                   	push   %ebx
801044b2:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801044b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801044b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801044bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801044c3:	e8 a8 fb ff ff       	call   80104070 <argstr>
801044c8:	85 c0                	test   %eax,%eax
801044ca:	0f 88 e1 00 00 00    	js     801045b1 <sys_link+0x105>
801044d0:	8d 45 d0             	lea    -0x30(%ebp),%eax
801044d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801044d7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801044de:	e8 8d fb ff ff       	call   80104070 <argstr>
801044e3:	85 c0                	test   %eax,%eax
801044e5:	0f 88 c6 00 00 00    	js     801045b1 <sys_link+0x105>
  begin_op();
801044eb:	e8 a8 e2 ff ff       	call   80102798 <begin_op>
  if((ip = namei(old)) == 0){
801044f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801044f3:	89 04 24             	mov    %eax,(%esp)
801044f6:	e8 2d d8 ff ff       	call   80101d28 <namei>
801044fb:	89 c3                	mov    %eax,%ebx
801044fd:	85 c0                	test   %eax,%eax
801044ff:	0f 84 a7 00 00 00    	je     801045ac <sys_link+0x100>
  ilock(ip);
80104505:	89 04 24             	mov    %eax,(%esp)
80104508:	e8 43 d0 ff ff       	call   80101550 <ilock>
  if(ip->type == T_DIR){
8010450d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104512:	0f 84 8c 00 00 00    	je     801045a4 <sys_link+0xf8>
  ip->nlink++;
80104518:	66 ff 43 56          	incw   0x56(%ebx)
  iupdate(ip);
8010451c:	89 1c 24             	mov    %ebx,(%esp)
8010451f:	e8 74 cf ff ff       	call   80101498 <iupdate>
  iunlock(ip);
80104524:	89 1c 24             	mov    %ebx,(%esp)
80104527:	e8 f4 d0 ff ff       	call   80101620 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
8010452c:	8d 7d da             	lea    -0x26(%ebp),%edi
8010452f:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104533:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104536:	89 04 24             	mov    %eax,(%esp)
80104539:	e8 02 d8 ff ff       	call   80101d40 <nameiparent>
8010453e:	89 c6                	mov    %eax,%esi
80104540:	85 c0                	test   %eax,%eax
80104542:	74 4c                	je     80104590 <sys_link+0xe4>
  ilock(dp);
80104544:	89 04 24             	mov    %eax,(%esp)
80104547:	e8 04 d0 ff ff       	call   80101550 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010454c:	8b 03                	mov    (%ebx),%eax
8010454e:	39 06                	cmp    %eax,(%esi)
80104550:	75 36                	jne    80104588 <sys_link+0xdc>
80104552:	8b 43 04             	mov    0x4(%ebx),%eax
80104555:	89 44 24 08          	mov    %eax,0x8(%esp)
80104559:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010455d:	89 34 24             	mov    %esi,(%esp)
80104560:	e8 eb d6 ff ff       	call   80101c50 <dirlink>
80104565:	85 c0                	test   %eax,%eax
80104567:	78 1f                	js     80104588 <sys_link+0xdc>
  iunlockput(dp);
80104569:	89 34 24             	mov    %esi,(%esp)
8010456c:	e8 2f d2 ff ff       	call   801017a0 <iunlockput>
  iput(ip);
80104571:	89 1c 24             	mov    %ebx,(%esp)
80104574:	e8 e7 d0 ff ff       	call   80101660 <iput>
  end_op();
80104579:	e8 76 e2 ff ff       	call   801027f4 <end_op>
  return 0;
8010457e:	31 c0                	xor    %eax,%eax
}
80104580:	83 c4 3c             	add    $0x3c,%esp
80104583:	5b                   	pop    %ebx
80104584:	5e                   	pop    %esi
80104585:	5f                   	pop    %edi
80104586:	5d                   	pop    %ebp
80104587:	c3                   	ret    
    iunlockput(dp);
80104588:	89 34 24             	mov    %esi,(%esp)
8010458b:	e8 10 d2 ff ff       	call   801017a0 <iunlockput>
  ilock(ip);
80104590:	89 1c 24             	mov    %ebx,(%esp)
80104593:	e8 b8 cf ff ff       	call   80101550 <ilock>
  ip->nlink--;
80104598:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
8010459c:	89 1c 24             	mov    %ebx,(%esp)
8010459f:	e8 f4 ce ff ff       	call   80101498 <iupdate>
  iunlockput(ip);
801045a4:	89 1c 24             	mov    %ebx,(%esp)
801045a7:	e8 f4 d1 ff ff       	call   801017a0 <iunlockput>
  end_op();
801045ac:	e8 43 e2 ff ff       	call   801027f4 <end_op>
  return -1;
801045b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045b6:	83 c4 3c             	add    $0x3c,%esp
801045b9:	5b                   	pop    %ebx
801045ba:	5e                   	pop    %esi
801045bb:	5f                   	pop    %edi
801045bc:	5d                   	pop    %ebp
801045bd:	c3                   	ret    
801045be:	66 90                	xchg   %ax,%ax

801045c0 <sys_unlink>:
{
801045c0:	55                   	push   %ebp
801045c1:	89 e5                	mov    %esp,%ebp
801045c3:	57                   	push   %edi
801045c4:	56                   	push   %esi
801045c5:	53                   	push   %ebx
801045c6:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
801045c9:	8d 45 c0             	lea    -0x40(%ebp),%eax
801045cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801045d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801045d7:	e8 94 fa ff ff       	call   80104070 <argstr>
801045dc:	85 c0                	test   %eax,%eax
801045de:	0f 88 70 01 00 00    	js     80104754 <sys_unlink+0x194>
  begin_op();
801045e4:	e8 af e1 ff ff       	call   80102798 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801045e9:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801045ec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801045f0:	8b 45 c0             	mov    -0x40(%ebp),%eax
801045f3:	89 04 24             	mov    %eax,(%esp)
801045f6:	e8 45 d7 ff ff       	call   80101d40 <nameiparent>
801045fb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
801045fe:	85 c0                	test   %eax,%eax
80104600:	0f 84 49 01 00 00    	je     8010474f <sys_unlink+0x18f>
  ilock(dp);
80104606:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104609:	89 04 24             	mov    %eax,(%esp)
8010460c:	e8 3f cf ff ff       	call   80101550 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104611:	c7 44 24 04 68 73 10 	movl   $0x80107368,0x4(%esp)
80104618:	80 
80104619:	89 1c 24             	mov    %ebx,(%esp)
8010461c:	e8 f3 d3 ff ff       	call   80101a14 <namecmp>
80104621:	85 c0                	test   %eax,%eax
80104623:	0f 84 1b 01 00 00    	je     80104744 <sys_unlink+0x184>
80104629:	c7 44 24 04 67 73 10 	movl   $0x80107367,0x4(%esp)
80104630:	80 
80104631:	89 1c 24             	mov    %ebx,(%esp)
80104634:	e8 db d3 ff ff       	call   80101a14 <namecmp>
80104639:	85 c0                	test   %eax,%eax
8010463b:	0f 84 03 01 00 00    	je     80104744 <sys_unlink+0x184>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104641:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104644:	89 44 24 08          	mov    %eax,0x8(%esp)
80104648:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010464c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010464f:	89 04 24             	mov    %eax,(%esp)
80104652:	e8 e1 d3 ff ff       	call   80101a38 <dirlookup>
80104657:	89 c3                	mov    %eax,%ebx
80104659:	85 c0                	test   %eax,%eax
8010465b:	0f 84 e3 00 00 00    	je     80104744 <sys_unlink+0x184>
  ilock(ip);
80104661:	89 04 24             	mov    %eax,(%esp)
80104664:	e8 e7 ce ff ff       	call   80101550 <ilock>
  if(ip->nlink < 1)
80104669:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010466e:	0f 8e 1c 01 00 00    	jle    80104790 <sys_unlink+0x1d0>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104674:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104679:	74 7d                	je     801046f8 <sys_unlink+0x138>
8010467b:	8d 75 d8             	lea    -0x28(%ebp),%esi
  memset(&de, 0, sizeof(de));
8010467e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104685:	00 
80104686:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010468d:	00 
8010468e:	89 34 24             	mov    %esi,(%esp)
80104691:	e8 ee f6 ff ff       	call   80103d84 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104696:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010469d:	00 
8010469e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801046a1:	89 44 24 08          	mov    %eax,0x8(%esp)
801046a5:	89 74 24 04          	mov    %esi,0x4(%esp)
801046a9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801046ac:	89 04 24             	mov    %eax,(%esp)
801046af:	e8 3c d2 ff ff       	call   801018f0 <writei>
801046b4:	83 f8 10             	cmp    $0x10,%eax
801046b7:	0f 85 c7 00 00 00    	jne    80104784 <sys_unlink+0x1c4>
  if(ip->type == T_DIR){
801046bd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801046c2:	0f 84 9c 00 00 00    	je     80104764 <sys_unlink+0x1a4>
  iunlockput(dp);
801046c8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801046cb:	89 04 24             	mov    %eax,(%esp)
801046ce:	e8 cd d0 ff ff       	call   801017a0 <iunlockput>
  ip->nlink--;
801046d3:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
801046d7:	89 1c 24             	mov    %ebx,(%esp)
801046da:	e8 b9 cd ff ff       	call   80101498 <iupdate>
  iunlockput(ip);
801046df:	89 1c 24             	mov    %ebx,(%esp)
801046e2:	e8 b9 d0 ff ff       	call   801017a0 <iunlockput>
  end_op();
801046e7:	e8 08 e1 ff ff       	call   801027f4 <end_op>
  return 0;
801046ec:	31 c0                	xor    %eax,%eax
}
801046ee:	83 c4 5c             	add    $0x5c,%esp
801046f1:	5b                   	pop    %ebx
801046f2:	5e                   	pop    %esi
801046f3:	5f                   	pop    %edi
801046f4:	5d                   	pop    %ebp
801046f5:	c3                   	ret    
801046f6:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801046f8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
801046fc:	0f 86 79 ff ff ff    	jbe    8010467b <sys_unlink+0xbb>
80104702:	bf 20 00 00 00       	mov    $0x20,%edi
80104707:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010470a:	eb 0c                	jmp    80104718 <sys_unlink+0x158>
8010470c:	83 c7 10             	add    $0x10,%edi
8010470f:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104712:	0f 83 66 ff ff ff    	jae    8010467e <sys_unlink+0xbe>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104718:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010471f:	00 
80104720:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104724:	89 74 24 04          	mov    %esi,0x4(%esp)
80104728:	89 1c 24             	mov    %ebx,(%esp)
8010472b:	e8 bc d0 ff ff       	call   801017ec <readi>
80104730:	83 f8 10             	cmp    $0x10,%eax
80104733:	75 43                	jne    80104778 <sys_unlink+0x1b8>
    if(de.inum != 0)
80104735:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010473a:	74 d0                	je     8010470c <sys_unlink+0x14c>
    iunlockput(ip);
8010473c:	89 1c 24             	mov    %ebx,(%esp)
8010473f:	e8 5c d0 ff ff       	call   801017a0 <iunlockput>
  iunlockput(dp);
80104744:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104747:	89 04 24             	mov    %eax,(%esp)
8010474a:	e8 51 d0 ff ff       	call   801017a0 <iunlockput>
  end_op();
8010474f:	e8 a0 e0 ff ff       	call   801027f4 <end_op>
  return -1;
80104754:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104759:	83 c4 5c             	add    $0x5c,%esp
8010475c:	5b                   	pop    %ebx
8010475d:	5e                   	pop    %esi
8010475e:	5f                   	pop    %edi
8010475f:	5d                   	pop    %ebp
80104760:	c3                   	ret    
80104761:	8d 76 00             	lea    0x0(%esi),%esi
    dp->nlink--;
80104764:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104767:	66 ff 48 56          	decw   0x56(%eax)
    iupdate(dp);
8010476b:	89 04 24             	mov    %eax,(%esp)
8010476e:	e8 25 cd ff ff       	call   80101498 <iupdate>
80104773:	e9 50 ff ff ff       	jmp    801046c8 <sys_unlink+0x108>
      panic("isdirempty: readi");
80104778:	c7 04 24 8c 73 10 80 	movl   $0x8010738c,(%esp)
8010477f:	e8 8c bb ff ff       	call   80100310 <panic>
    panic("unlink: writei");
80104784:	c7 04 24 9e 73 10 80 	movl   $0x8010739e,(%esp)
8010478b:	e8 80 bb ff ff       	call   80100310 <panic>
    panic("unlink: nlink < 1");
80104790:	c7 04 24 7a 73 10 80 	movl   $0x8010737a,(%esp)
80104797:	e8 74 bb ff ff       	call   80100310 <panic>

8010479c <sys_open>:

int
sys_open(void)
{
8010479c:	55                   	push   %ebp
8010479d:	89 e5                	mov    %esp,%ebp
8010479f:	56                   	push   %esi
801047a0:	53                   	push   %ebx
801047a1:	83 ec 30             	sub    $0x30,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801047a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801047a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801047ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801047b2:	e8 b9 f8 ff ff       	call   80104070 <argstr>
801047b7:	85 c0                	test   %eax,%eax
801047b9:	0f 88 ce 00 00 00    	js     8010488d <sys_open+0xf1>
801047bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
801047c2:	89 44 24 04          	mov    %eax,0x4(%esp)
801047c6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801047cd:	e8 1e f8 ff ff       	call   80103ff0 <argint>
801047d2:	85 c0                	test   %eax,%eax
801047d4:	0f 88 b3 00 00 00    	js     8010488d <sys_open+0xf1>
    return -1;

  begin_op();
801047da:	e8 b9 df ff ff       	call   80102798 <begin_op>

  if(omode & O_CREATE){
801047df:	f6 45 f5 02          	testb  $0x2,-0xb(%ebp)
801047e3:	0f 85 83 00 00 00    	jne    8010486c <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801047e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047ec:	89 04 24             	mov    %eax,(%esp)
801047ef:	e8 34 d5 ff ff       	call   80101d28 <namei>
801047f4:	89 c6                	mov    %eax,%esi
801047f6:	85 c0                	test   %eax,%eax
801047f8:	0f 84 8a 00 00 00    	je     80104888 <sys_open+0xec>
      end_op();
      return -1;
    }
    ilock(ip);
801047fe:	89 04 24             	mov    %eax,(%esp)
80104801:	e8 4a cd ff ff       	call   80101550 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104806:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
8010480b:	0f 84 8b 00 00 00    	je     8010489c <sys_open+0x100>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104811:	e8 82 c4 ff ff       	call   80100c98 <filealloc>
80104816:	89 c3                	mov    %eax,%ebx
80104818:	85 c0                	test   %eax,%eax
8010481a:	0f 84 88 00 00 00    	je     801048a8 <sys_open+0x10c>
80104820:	e8 e7 f8 ff ff       	call   8010410c <fdalloc>
80104825:	85 c0                	test   %eax,%eax
80104827:	0f 88 87 00 00 00    	js     801048b4 <sys_open+0x118>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010482d:	89 34 24             	mov    %esi,(%esp)
80104830:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104833:	e8 e8 cd ff ff       	call   80101620 <iunlock>
  end_op();
80104838:	e8 b7 df ff ff       	call   801027f4 <end_op>

  f->type = FD_INODE;
8010483d:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104843:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104846:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
8010484d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104850:	89 ca                	mov    %ecx,%edx
80104852:	83 e2 01             	and    $0x1,%edx
80104855:	83 f2 01             	xor    $0x1,%edx
80104858:	88 53 08             	mov    %dl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010485b:	83 e1 03             	and    $0x3,%ecx
8010485e:	0f 95 43 09          	setne  0x9(%ebx)
80104862:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  return fd;
}
80104865:	83 c4 30             	add    $0x30,%esp
80104868:	5b                   	pop    %ebx
80104869:	5e                   	pop    %esi
8010486a:	5d                   	pop    %ebp
8010486b:	c3                   	ret    
    ip = create(path, T_FILE, 0, 0);
8010486c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104873:	31 c9                	xor    %ecx,%ecx
80104875:	ba 02 00 00 00       	mov    $0x2,%edx
8010487a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010487d:	e8 ba f8 ff ff       	call   8010413c <create>
80104882:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104884:	85 c0                	test   %eax,%eax
80104886:	75 89                	jne    80104811 <sys_open+0x75>
    end_op();
80104888:	e8 67 df ff ff       	call   801027f4 <end_op>
    return -1;
8010488d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104892:	83 c4 30             	add    $0x30,%esp
80104895:	5b                   	pop    %ebx
80104896:	5e                   	pop    %esi
80104897:	5d                   	pop    %ebp
80104898:	c3                   	ret    
80104899:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
8010489c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010489f:	85 db                	test   %ebx,%ebx
801048a1:	0f 84 6a ff ff ff    	je     80104811 <sys_open+0x75>
801048a7:	90                   	nop
    iunlockput(ip);
801048a8:	89 34 24             	mov    %esi,(%esp)
801048ab:	e8 f0 ce ff ff       	call   801017a0 <iunlockput>
801048b0:	eb d6                	jmp    80104888 <sys_open+0xec>
801048b2:	66 90                	xchg   %ax,%ax
      fileclose(f);
801048b4:	89 1c 24             	mov    %ebx,(%esp)
801048b7:	e8 84 c4 ff ff       	call   80100d40 <fileclose>
801048bc:	eb ea                	jmp    801048a8 <sys_open+0x10c>
801048be:	66 90                	xchg   %ax,%ax

801048c0 <sys_mkdir>:

int
sys_mkdir(void)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801048c6:	e8 cd de ff ff       	call   80102798 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801048cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801048d2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801048d9:	e8 92 f7 ff ff       	call   80104070 <argstr>
801048de:	85 c0                	test   %eax,%eax
801048e0:	78 2e                	js     80104910 <sys_mkdir+0x50>
801048e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801048e9:	31 c9                	xor    %ecx,%ecx
801048eb:	ba 01 00 00 00       	mov    $0x1,%edx
801048f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f3:	e8 44 f8 ff ff       	call   8010413c <create>
801048f8:	85 c0                	test   %eax,%eax
801048fa:	74 14                	je     80104910 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
801048fc:	89 04 24             	mov    %eax,(%esp)
801048ff:	e8 9c ce ff ff       	call   801017a0 <iunlockput>
  end_op();
80104904:	e8 eb de ff ff       	call   801027f4 <end_op>
  return 0;
80104909:	31 c0                	xor    %eax,%eax
}
8010490b:	c9                   	leave  
8010490c:	c3                   	ret    
8010490d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104910:	e8 df de ff ff       	call   801027f4 <end_op>
    return -1;
80104915:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010491a:	c9                   	leave  
8010491b:	c3                   	ret    

8010491c <sys_mknod>:

int
sys_mknod(void)
{
8010491c:	55                   	push   %ebp
8010491d:	89 e5                	mov    %esp,%ebp
8010491f:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104922:	e8 71 de ff ff       	call   80102798 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104927:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010492a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010492e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104935:	e8 36 f7 ff ff       	call   80104070 <argstr>
8010493a:	85 c0                	test   %eax,%eax
8010493c:	78 5e                	js     8010499c <sys_mknod+0x80>
     argint(1, &major) < 0 ||
8010493e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104941:	89 44 24 04          	mov    %eax,0x4(%esp)
80104945:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010494c:	e8 9f f6 ff ff       	call   80103ff0 <argint>
  if((argstr(0, &path)) < 0 ||
80104951:	85 c0                	test   %eax,%eax
80104953:	78 47                	js     8010499c <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80104955:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104958:	89 44 24 04          	mov    %eax,0x4(%esp)
8010495c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104963:	e8 88 f6 ff ff       	call   80103ff0 <argint>
     argint(1, &major) < 0 ||
80104968:	85 c0                	test   %eax,%eax
8010496a:	78 30                	js     8010499c <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010496c:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104970:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80104974:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
80104977:	ba 03 00 00 00       	mov    $0x3,%edx
8010497c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010497f:	e8 b8 f7 ff ff       	call   8010413c <create>
80104984:	85 c0                	test   %eax,%eax
80104986:	74 14                	je     8010499c <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104988:	89 04 24             	mov    %eax,(%esp)
8010498b:	e8 10 ce ff ff       	call   801017a0 <iunlockput>
  end_op();
80104990:	e8 5f de ff ff       	call   801027f4 <end_op>
  return 0;
80104995:	31 c0                	xor    %eax,%eax
}
80104997:	c9                   	leave  
80104998:	c3                   	ret    
80104999:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
8010499c:	e8 53 de ff ff       	call   801027f4 <end_op>
    return -1;
801049a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049a6:	c9                   	leave  
801049a7:	c3                   	ret    

801049a8 <sys_chdir>:

int
sys_chdir(void)
{
801049a8:	55                   	push   %ebp
801049a9:	89 e5                	mov    %esp,%ebp
801049ab:	56                   	push   %esi
801049ac:	53                   	push   %ebx
801049ad:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801049b0:	e8 db e8 ff ff       	call   80103290 <myproc>
801049b5:	89 c6                	mov    %eax,%esi
  
  begin_op();
801049b7:	e8 dc dd ff ff       	call   80102798 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801049bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049bf:	89 44 24 04          	mov    %eax,0x4(%esp)
801049c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801049ca:	e8 a1 f6 ff ff       	call   80104070 <argstr>
801049cf:	85 c0                	test   %eax,%eax
801049d1:	78 4a                	js     80104a1d <sys_chdir+0x75>
801049d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d6:	89 04 24             	mov    %eax,(%esp)
801049d9:	e8 4a d3 ff ff       	call   80101d28 <namei>
801049de:	89 c3                	mov    %eax,%ebx
801049e0:	85 c0                	test   %eax,%eax
801049e2:	74 39                	je     80104a1d <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
801049e4:	89 04 24             	mov    %eax,(%esp)
801049e7:	e8 64 cb ff ff       	call   80101550 <ilock>
  if(ip->type != T_DIR){
801049ec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
801049f1:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
801049f4:	75 22                	jne    80104a18 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
801049f6:	e8 25 cc ff ff       	call   80101620 <iunlock>
  iput(curproc->cwd);
801049fb:	8b 46 68             	mov    0x68(%esi),%eax
801049fe:	89 04 24             	mov    %eax,(%esp)
80104a01:	e8 5a cc ff ff       	call   80101660 <iput>
  end_op();
80104a06:	e8 e9 dd ff ff       	call   801027f4 <end_op>
  curproc->cwd = ip;
80104a0b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104a0e:	31 c0                	xor    %eax,%eax
}
80104a10:	83 c4 20             	add    $0x20,%esp
80104a13:	5b                   	pop    %ebx
80104a14:	5e                   	pop    %esi
80104a15:	5d                   	pop    %ebp
80104a16:	c3                   	ret    
80104a17:	90                   	nop
    iunlockput(ip);
80104a18:	e8 83 cd ff ff       	call   801017a0 <iunlockput>
    end_op();
80104a1d:	e8 d2 dd ff ff       	call   801027f4 <end_op>
    return -1;
80104a22:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a27:	83 c4 20             	add    $0x20,%esp
80104a2a:	5b                   	pop    %ebx
80104a2b:	5e                   	pop    %esi
80104a2c:	5d                   	pop    %ebp
80104a2d:	c3                   	ret    
80104a2e:	66 90                	xchg   %ax,%ax

80104a30 <sys_exec>:

int
sys_exec(void)
{
80104a30:	55                   	push   %ebp
80104a31:	89 e5                	mov    %esp,%ebp
80104a33:	57                   	push   %edi
80104a34:	56                   	push   %esi
80104a35:	53                   	push   %ebx
80104a36:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104a3c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80104a42:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a46:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104a4d:	e8 1e f6 ff ff       	call   80104070 <argstr>
80104a52:	85 c0                	test   %eax,%eax
80104a54:	0f 88 89 00 00 00    	js     80104ae3 <sys_exec+0xb3>
80104a5a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80104a60:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a6b:	e8 80 f5 ff ff       	call   80103ff0 <argint>
80104a70:	85 c0                	test   %eax,%eax
80104a72:	78 6f                	js     80104ae3 <sys_exec+0xb3>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104a74:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80104a7b:	00 
80104a7c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104a83:	00 
80104a84:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80104a8a:	89 04 24             	mov    %eax,(%esp)
80104a8d:	e8 f2 f2 ff ff       	call   80103d84 <memset>
  for(i=0;; i++){
80104a92:	31 db                	xor    %ebx,%ebx
80104a94:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80104a9a:	66 90                	xchg   %ax,%ax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104a9c:	89 7c 24 04          	mov    %edi,0x4(%esp)
sys_exec(void)
80104aa0:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104aa7:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80104aad:	01 f0                	add    %esi,%eax
80104aaf:	89 04 24             	mov    %eax,(%esp)
80104ab2:	e8 c5 f4 ff ff       	call   80103f7c <fetchint>
80104ab7:	85 c0                	test   %eax,%eax
80104ab9:	78 28                	js     80104ae3 <sys_exec+0xb3>
      return -1;
    if(uarg == 0){
80104abb:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80104ac1:	85 c0                	test   %eax,%eax
80104ac3:	74 2f                	je     80104af4 <sys_exec+0xc4>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80104ac5:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
80104acb:	01 d6                	add    %edx,%esi
80104acd:	89 74 24 04          	mov    %esi,0x4(%esp)
80104ad1:	89 04 24             	mov    %eax,(%esp)
80104ad4:	e8 d3 f4 ff ff       	call   80103fac <fetchstr>
80104ad9:	85 c0                	test   %eax,%eax
80104adb:	78 06                	js     80104ae3 <sys_exec+0xb3>
  for(i=0;; i++){
80104add:	43                   	inc    %ebx
    if(i >= NELEM(argv))
80104ade:	83 fb 20             	cmp    $0x20,%ebx
80104ae1:	75 b9                	jne    80104a9c <sys_exec+0x6c>
    return -1;
80104ae3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  return exec(path, argv);
}
80104ae8:	81 c4 ac 00 00 00    	add    $0xac,%esp
80104aee:	5b                   	pop    %ebx
80104aef:	5e                   	pop    %esi
80104af0:	5f                   	pop    %edi
80104af1:	5d                   	pop    %ebp
80104af2:	c3                   	ret    
80104af3:	90                   	nop
      argv[i] = 0;
80104af4:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80104afb:	00 00 00 00 
  return exec(path, argv);
80104aff:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
80104b05:	89 54 24 04          	mov    %edx,0x4(%esp)
80104b09:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80104b0f:	89 04 24             	mov    %eax,(%esp)
80104b12:	e8 c5 bd ff ff       	call   801008dc <exec>
}
80104b17:	81 c4 ac 00 00 00    	add    $0xac,%esp
80104b1d:	5b                   	pop    %ebx
80104b1e:	5e                   	pop    %esi
80104b1f:	5f                   	pop    %edi
80104b20:	5d                   	pop    %ebp
80104b21:	c3                   	ret    
80104b22:	66 90                	xchg   %ax,%ax

80104b24 <sys_pipe>:

int
sys_pipe(void)
{
80104b24:	55                   	push   %ebp
80104b25:	89 e5                	mov    %esp,%ebp
80104b27:	53                   	push   %ebx
80104b28:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104b2b:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80104b32:	00 
80104b33:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104b36:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b3a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104b41:	e8 d2 f4 ff ff       	call   80104018 <argptr>
80104b46:	85 c0                	test   %eax,%eax
80104b48:	78 69                	js     80104bb3 <sys_pipe+0x8f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104b4a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b51:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b54:	89 04 24             	mov    %eax,(%esp)
80104b57:	e8 08 e2 ff ff       	call   80102d64 <pipealloc>
80104b5c:	85 c0                	test   %eax,%eax
80104b5e:	78 53                	js     80104bb3 <sys_pipe+0x8f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b63:	e8 a4 f5 ff ff       	call   8010410c <fdalloc>
80104b68:	89 c3                	mov    %eax,%ebx
80104b6a:	85 c0                	test   %eax,%eax
80104b6c:	78 2f                	js     80104b9d <sys_pipe+0x79>
80104b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b71:	e8 96 f5 ff ff       	call   8010410c <fdalloc>
80104b76:	85 c0                	test   %eax,%eax
80104b78:	78 16                	js     80104b90 <sys_pipe+0x6c>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104b7a:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104b7d:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104b7f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104b82:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104b85:	31 c0                	xor    %eax,%eax
}
80104b87:	83 c4 24             	add    $0x24,%esp
80104b8a:	5b                   	pop    %ebx
80104b8b:	5d                   	pop    %ebp
80104b8c:	c3                   	ret    
80104b8d:	8d 76 00             	lea    0x0(%esi),%esi
      myproc()->ofile[fd0] = 0;
80104b90:	e8 fb e6 ff ff       	call   80103290 <myproc>
80104b95:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104b9c:	00 
    fileclose(rf);
80104b9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ba0:	89 04 24             	mov    %eax,(%esp)
80104ba3:	e8 98 c1 ff ff       	call   80100d40 <fileclose>
    fileclose(wf);
80104ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bab:	89 04 24             	mov    %eax,(%esp)
80104bae:	e8 8d c1 ff ff       	call   80100d40 <fileclose>
    return -1;
80104bb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bb8:	83 c4 24             	add    $0x24,%esp
80104bbb:	5b                   	pop    %ebx
80104bbc:	5d                   	pop    %ebp
80104bbd:	c3                   	ret    
80104bbe:	66 90                	xchg   %ax,%ax

80104bc0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80104bc3:	5d                   	pop    %ebp
  return fork();
80104bc4:	e9 b7 e8 ff ff       	jmp    80103480 <fork>
80104bc9:	8d 76 00             	lea    0x0(%esi),%esi

80104bcc <sys_yield>:

int
sys_yield(void)
{
80104bcc:	55                   	push   %ebp
80104bcd:	89 e5                	mov    %esp,%ebp
80104bcf:	83 ec 08             	sub    $0x8,%esp
  
  if(ticks % 2 == 0){
80104bd2:	f6 05 a0 57 11 80 01 	testb  $0x1,0x801157a0
80104bd9:	75 05                	jne    80104be0 <sys_yield+0x14>
    MLFQ_tick_adder();
80104bdb:	e8 f8 1e 00 00       	call   80106ad8 <MLFQ_tick_adder>
  }

  yield();
80104be0:	e8 a3 eb ff ff       	call   80103788 <yield>
  return 0;
}
80104be5:	31 c0                	xor    %eax,%eax
80104be7:	c9                   	leave  
80104be8:	c3                   	ret    
80104be9:	8d 76 00             	lea    0x0(%esi),%esi

80104bec <sys_exit>:

int
sys_exit(void)
{
80104bec:	55                   	push   %ebp
80104bed:	89 e5                	mov    %esp,%ebp
80104bef:	83 ec 08             	sub    $0x8,%esp
  exit();
80104bf2:	e8 39 ea ff ff       	call   80103630 <exit>
  return 0;  // not reached
}
80104bf7:	31 c0                	xor    %eax,%eax
80104bf9:	c9                   	leave  
80104bfa:	c3                   	ret    
80104bfb:	90                   	nop

80104bfc <sys_wait>:

int
sys_wait(void)
{
80104bfc:	55                   	push   %ebp
80104bfd:	89 e5                	mov    %esp,%ebp
  return wait();
}
80104bff:	5d                   	pop    %ebp
  return wait();
80104c00:	e9 5b ec ff ff       	jmp    80103860 <wait>
80104c05:	8d 76 00             	lea    0x0(%esi),%esi

80104c08 <sys_kill>:

int
sys_kill(void)
{
80104c08:	55                   	push   %ebp
80104c09:	89 e5                	mov    %esp,%ebp
80104c0b:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104c0e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c11:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c1c:	e8 cf f3 ff ff       	call   80103ff0 <argint>
80104c21:	85 c0                	test   %eax,%eax
80104c23:	78 0f                	js     80104c34 <sys_kill+0x2c>
    return -1;
  return kill(pid);
80104c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c28:	89 04 24             	mov    %eax,(%esp)
80104c2b:	e8 6c ed ff ff       	call   8010399c <kill>
}
80104c30:	c9                   	leave  
80104c31:	c3                   	ret    
80104c32:	66 90                	xchg   %ax,%ax
    return -1;
80104c34:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c39:	c9                   	leave  
80104c3a:	c3                   	ret    
80104c3b:	90                   	nop

80104c3c <sys_getpid>:

int
sys_getpid(void)
{
80104c3c:	55                   	push   %ebp
80104c3d:	89 e5                	mov    %esp,%ebp
80104c3f:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104c42:	e8 49 e6 ff ff       	call   80103290 <myproc>
80104c47:	8b 40 10             	mov    0x10(%eax),%eax
}
80104c4a:	c9                   	leave  
80104c4b:	c3                   	ret    

80104c4c <sys_getppid>:

int
sys_getppid(void)
{
80104c4c:	55                   	push   %ebp
80104c4d:	89 e5                	mov    %esp,%ebp
80104c4f:	83 ec 08             	sub    $0x8,%esp
    return myproc()->parent->pid;
80104c52:	e8 39 e6 ff ff       	call   80103290 <myproc>
80104c57:	8b 40 14             	mov    0x14(%eax),%eax
80104c5a:	8b 40 10             	mov    0x10(%eax),%eax
}
80104c5d:	c9                   	leave  
80104c5e:	c3                   	ret    
80104c5f:	90                   	nop

80104c60 <sys_getlev>:

int
sys_getlev(void)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	83 ec 08             	sub    $0x8,%esp
  return myproc()->prior;
80104c66:	e8 25 e6 ff ff       	call   80103290 <myproc>
80104c6b:	8b 40 7c             	mov    0x7c(%eax),%eax
}
80104c6e:	c9                   	leave  
80104c6f:	c3                   	ret    

80104c70 <sys_set_cpu_share>:

int
sys_set_cpu_share(void)
{
80104c70:	55                   	push   %ebp
80104c71:	89 e5                	mov    %esp,%ebp
80104c73:	83 ec 28             	sub    $0x28,%esp
  int n;
  if(argint(0, &n) < 0)
80104c76:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c79:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c7d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c84:	e8 67 f3 ff ff       	call   80103ff0 <argint>
80104c89:	85 c0                	test   %eax,%eax
80104c8b:	78 0f                	js     80104c9c <sys_set_cpu_share+0x2c>
    return -1;
  return set_cpu_share(n);
80104c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c90:	89 04 24             	mov    %eax,(%esp)
80104c93:	e8 bc 1c 00 00       	call   80106954 <set_cpu_share>
}
80104c98:	c9                   	leave  
80104c99:	c3                   	ret    
80104c9a:	66 90                	xchg   %ax,%ax
    return -1;
80104c9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ca1:	c9                   	leave  
80104ca2:	c3                   	ret    
80104ca3:	90                   	nop

80104ca4 <sys_sbrk>:

int
sys_sbrk(void)
{
80104ca4:	55                   	push   %ebp
80104ca5:	89 e5                	mov    %esp,%ebp
80104ca7:	53                   	push   %ebx
80104ca8:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104cab:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cae:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cb2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104cb9:	e8 32 f3 ff ff       	call   80103ff0 <argint>
80104cbe:	85 c0                	test   %eax,%eax
80104cc0:	78 1e                	js     80104ce0 <sys_sbrk+0x3c>
    return -1;
  addr = myproc()->sz;
80104cc2:	e8 c9 e5 ff ff       	call   80103290 <myproc>
80104cc7:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80104cc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ccc:	89 04 24             	mov    %eax,(%esp)
80104ccf:	e8 40 e7 ff ff       	call   80103414 <growproc>
80104cd4:	85 c0                	test   %eax,%eax
80104cd6:	78 08                	js     80104ce0 <sys_sbrk+0x3c>
    return -1;
  return addr;
}
80104cd8:	89 d8                	mov    %ebx,%eax
80104cda:	83 c4 24             	add    $0x24,%esp
80104cdd:	5b                   	pop    %ebx
80104cde:	5d                   	pop    %ebp
80104cdf:	c3                   	ret    
    return -1;
80104ce0:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104ce5:	eb f1                	jmp    80104cd8 <sys_sbrk+0x34>
80104ce7:	90                   	nop

80104ce8 <sys_sleep>:

int
sys_sleep(void)
{
80104ce8:	55                   	push   %ebp
80104ce9:	89 e5                	mov    %esp,%ebp
80104ceb:	53                   	push   %ebx
80104cec:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104cef:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cf2:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cf6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104cfd:	e8 ee f2 ff ff       	call   80103ff0 <argint>
80104d02:	85 c0                	test   %eax,%eax
80104d04:	78 76                	js     80104d7c <sys_sleep+0x94>
    return -1;
  acquire(&tickslock);
80104d06:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80104d0d:	e8 6e ef ff ff       	call   80103c80 <acquire>
  ticks0 = ticks;
80104d12:	8b 1d a0 57 11 80    	mov    0x801157a0,%ebx
  while(ticks - ticks0 < n){
80104d18:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d1b:	85 d2                	test   %edx,%edx
80104d1d:	75 25                	jne    80104d44 <sys_sleep+0x5c>
80104d1f:	eb 47                	jmp    80104d68 <sys_sleep+0x80>
80104d21:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104d24:	c7 44 24 04 60 4f 11 	movl   $0x80114f60,0x4(%esp)
80104d2b:	80 
80104d2c:	c7 04 24 a0 57 11 80 	movl   $0x801157a0,(%esp)
80104d33:	e8 84 ea ff ff       	call   801037bc <sleep>
  while(ticks - ticks0 < n){
80104d38:	a1 a0 57 11 80       	mov    0x801157a0,%eax
80104d3d:	29 d8                	sub    %ebx,%eax
80104d3f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104d42:	73 24                	jae    80104d68 <sys_sleep+0x80>
    if(myproc()->killed){
80104d44:	e8 47 e5 ff ff       	call   80103290 <myproc>
80104d49:	8b 40 24             	mov    0x24(%eax),%eax
80104d4c:	85 c0                	test   %eax,%eax
80104d4e:	74 d4                	je     80104d24 <sys_sleep+0x3c>
      release(&tickslock);
80104d50:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80104d57:	e8 e0 ef ff ff       	call   80103d3c <release>
      return -1;
80104d5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80104d61:	83 c4 24             	add    $0x24,%esp
80104d64:	5b                   	pop    %ebx
80104d65:	5d                   	pop    %ebp
80104d66:	c3                   	ret    
80104d67:	90                   	nop
  release(&tickslock);
80104d68:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80104d6f:	e8 c8 ef ff ff       	call   80103d3c <release>
  return 0;
80104d74:	31 c0                	xor    %eax,%eax
}
80104d76:	83 c4 24             	add    $0x24,%esp
80104d79:	5b                   	pop    %ebx
80104d7a:	5d                   	pop    %ebp
80104d7b:	c3                   	ret    
    return -1;
80104d7c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d81:	eb de                	jmp    80104d61 <sys_sleep+0x79>
80104d83:	90                   	nop

80104d84 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80104d84:	55                   	push   %ebp
80104d85:	89 e5                	mov    %esp,%ebp
80104d87:	53                   	push   %ebx
80104d88:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80104d8b:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80104d92:	e8 e9 ee ff ff       	call   80103c80 <acquire>
  xticks = ticks;
80104d97:	8b 1d a0 57 11 80    	mov    0x801157a0,%ebx
  release(&tickslock);
80104d9d:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80104da4:	e8 93 ef ff ff       	call   80103d3c <release>
  return xticks;
}
80104da9:	89 d8                	mov    %ebx,%eax
80104dab:	83 c4 14             	add    $0x14,%esp
80104dae:	5b                   	pop    %ebx
80104daf:	5d                   	pop    %ebp
80104db0:	c3                   	ret    

80104db1 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80104db1:	1e                   	push   %ds
  pushl %es
80104db2:	06                   	push   %es
  pushl %fs
80104db3:	0f a0                	push   %fs
  pushl %gs
80104db5:	0f a8                	push   %gs
  pushal
80104db7:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80104db8:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80104dbc:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80104dbe:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80104dc0:	54                   	push   %esp
  call trap
80104dc1:	e8 ba 00 00 00       	call   80104e80 <trap>
  addl $4, %esp
80104dc6:	83 c4 04             	add    $0x4,%esp

80104dc9 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80104dc9:	61                   	popa   
  popl %gs
80104dca:	0f a9                	pop    %gs
  popl %fs
80104dcc:	0f a1                	pop    %fs
  popl %es
80104dce:	07                   	pop    %es
  popl %ds
80104dcf:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80104dd0:	83 c4 08             	add    $0x8,%esp
  iret
80104dd3:	cf                   	iret   

80104dd4 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80104dd4:	31 c0                	xor    %eax,%eax
80104dd6:	66 90                	xchg   %ax,%ax
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80104dd8:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80104ddf:	66 89 14 c5 a0 4f 11 	mov    %dx,-0x7feeb060(,%eax,8)
80104de6:	80 
80104de7:	66 c7 04 c5 a2 4f 11 	movw   $0x8,-0x7feeb05e(,%eax,8)
80104dee:	80 08 00 
80104df1:	c6 04 c5 a4 4f 11 80 	movb   $0x0,-0x7feeb05c(,%eax,8)
80104df8:	00 
80104df9:	c6 04 c5 a5 4f 11 80 	movb   $0x8e,-0x7feeb05b(,%eax,8)
80104e00:	8e 
80104e01:	c1 ea 10             	shr    $0x10,%edx
80104e04:	66 89 14 c5 a6 4f 11 	mov    %dx,-0x7feeb05a(,%eax,8)
80104e0b:	80 
  for(i = 0; i < 256; i++)
80104e0c:	40                   	inc    %eax
80104e0d:	3d 00 01 00 00       	cmp    $0x100,%eax
80104e12:	75 c4                	jne    80104dd8 <tvinit+0x4>
{
80104e14:	55                   	push   %ebp
80104e15:	89 e5                	mov    %esp,%ebp
80104e17:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80104e1a:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80104e1f:	66 a3 a0 51 11 80    	mov    %ax,0x801151a0
80104e25:	66 c7 05 a2 51 11 80 	movw   $0x8,0x801151a2
80104e2c:	08 00 
80104e2e:	c6 05 a4 51 11 80 00 	movb   $0x0,0x801151a4
80104e35:	c6 05 a5 51 11 80 ef 	movb   $0xef,0x801151a5
80104e3c:	c1 e8 10             	shr    $0x10,%eax
80104e3f:	66 a3 a6 51 11 80    	mov    %ax,0x801151a6

  initlock(&tickslock, "time");
80104e45:	c7 44 24 04 ad 73 10 	movl   $0x801073ad,0x4(%esp)
80104e4c:	80 
80104e4d:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80104e54:	e8 5f ed ff ff       	call   80103bb8 <initlock>
}
80104e59:	c9                   	leave  
80104e5a:	c3                   	ret    
80104e5b:	90                   	nop

80104e5c <idtinit>:

void
idtinit(void)
{
80104e5c:	55                   	push   %ebp
80104e5d:	89 e5                	mov    %esp,%ebp
80104e5f:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80104e62:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80104e68:	b8 a0 4f 11 80       	mov    $0x80114fa0,%eax
80104e6d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80104e71:	c1 e8 10             	shr    $0x10,%eax
80104e74:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80104e78:	8d 45 fa             	lea    -0x6(%ebp),%eax
80104e7b:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80104e7e:	c9                   	leave  
80104e7f:	c3                   	ret    

80104e80 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80104e80:	55                   	push   %ebp
80104e81:	89 e5                	mov    %esp,%ebp
80104e83:	57                   	push   %edi
80104e84:	56                   	push   %esi
80104e85:	53                   	push   %ebx
80104e86:	83 ec 3c             	sub    $0x3c,%esp
80104e89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80104e8c:	8b 43 30             	mov    0x30(%ebx),%eax
80104e8f:	83 f8 40             	cmp    $0x40,%eax
80104e92:	0f 84 c0 01 00 00    	je     80105058 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80104e98:	83 e8 20             	sub    $0x20,%eax
80104e9b:	83 f8 1f             	cmp    $0x1f,%eax
80104e9e:	0f 86 f4 00 00 00    	jbe    80104f98 <trap+0x118>
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80104ea4:	e8 e7 e3 ff ff       	call   80103290 <myproc>
80104ea9:	85 c0                	test   %eax,%eax
80104eab:	0f 84 f2 01 00 00    	je     801050a3 <trap+0x223>
80104eb1:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80104eb5:	0f 84 e8 01 00 00    	je     801050a3 <trap+0x223>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80104ebb:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80104ebe:	8b 53 38             	mov    0x38(%ebx),%edx
80104ec1:	89 55 dc             	mov    %edx,-0x24(%ebp)
80104ec4:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80104ec7:	e8 90 e3 ff ff       	call   8010325c <cpuid>
80104ecc:	89 c7                	mov    %eax,%edi
80104ece:	8b 73 34             	mov    0x34(%ebx),%esi
80104ed1:	8b 43 30             	mov    0x30(%ebx),%eax
80104ed4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80104ed7:	e8 b4 e3 ff ff       	call   80103290 <myproc>
80104edc:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104edf:	e8 ac e3 ff ff       	call   80103290 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80104ee4:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80104ee7:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
80104eeb:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104eee:	89 54 24 18          	mov    %edx,0x18(%esp)
80104ef2:	89 7c 24 14          	mov    %edi,0x14(%esp)
80104ef6:	89 74 24 10          	mov    %esi,0x10(%esp)
80104efa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104efd:	89 54 24 0c          	mov    %edx,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80104f01:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104f04:	83 c2 6c             	add    $0x6c,%edx
80104f07:	89 54 24 08          	mov    %edx,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80104f0b:	8b 40 10             	mov    0x10(%eax),%eax
80104f0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f12:	c7 04 24 10 74 10 80 	movl   $0x80107410,(%esp)
80104f19:	e8 96 b6 ff ff       	call   801005b4 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80104f1e:	e8 6d e3 ff ff       	call   80103290 <myproc>
80104f23:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80104f2a:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80104f2c:	e8 5f e3 ff ff       	call   80103290 <myproc>
80104f31:	85 c0                	test   %eax,%eax
80104f33:	74 1c                	je     80104f51 <trap+0xd1>
80104f35:	e8 56 e3 ff ff       	call   80103290 <myproc>
80104f3a:	8b 50 24             	mov    0x24(%eax),%edx
80104f3d:	85 d2                	test   %edx,%edx
80104f3f:	74 10                	je     80104f51 <trap+0xd1>
80104f41:	8b 43 3c             	mov    0x3c(%ebx),%eax
80104f44:	83 e0 03             	and    $0x3,%eax
80104f47:	66 83 f8 03          	cmp    $0x3,%ax
80104f4b:	0f 84 3f 01 00 00    	je     80105090 <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80104f51:	e8 3a e3 ff ff       	call   80103290 <myproc>
80104f56:	85 c0                	test   %eax,%eax
80104f58:	74 0f                	je     80104f69 <trap+0xe9>
80104f5a:	e8 31 e3 ff ff       	call   80103290 <myproc>
80104f5f:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80104f63:	0f 84 cb 00 00 00    	je     80105034 <trap+0x1b4>
    if(MLFQ_tick_adder()){
      yield();
    }   
  }
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80104f69:	e8 22 e3 ff ff       	call   80103290 <myproc>
80104f6e:	85 c0                	test   %eax,%eax
80104f70:	74 1c                	je     80104f8e <trap+0x10e>
80104f72:	e8 19 e3 ff ff       	call   80103290 <myproc>
80104f77:	8b 40 24             	mov    0x24(%eax),%eax
80104f7a:	85 c0                	test   %eax,%eax
80104f7c:	74 10                	je     80104f8e <trap+0x10e>
80104f7e:	8b 43 3c             	mov    0x3c(%ebx),%eax
80104f81:	83 e0 03             	and    $0x3,%eax
80104f84:	66 83 f8 03          	cmp    $0x3,%ax
80104f88:	0f 84 f3 00 00 00    	je     80105081 <trap+0x201>
    exit();
}
80104f8e:	83 c4 3c             	add    $0x3c,%esp
80104f91:	5b                   	pop    %ebx
80104f92:	5e                   	pop    %esi
80104f93:	5f                   	pop    %edi
80104f94:	5d                   	pop    %ebp
80104f95:	c3                   	ret    
80104f96:	66 90                	xchg   %ax,%ax
  switch(tf->trapno){
80104f98:	ff 24 85 54 74 10 80 	jmp    *-0x7fef8bac(,%eax,4)
80104f9f:	90                   	nop
    ideintr();
80104fa0:	e8 c7 ce ff ff       	call   80101e6c <ideintr>
    lapiceoi();
80104fa5:	e8 ce d4 ff ff       	call   80102478 <lapiceoi>
    break;
80104faa:	eb 80                	jmp    80104f2c <trap+0xac>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80104fac:	8b 7b 38             	mov    0x38(%ebx),%edi
80104faf:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80104fb3:	e8 a4 e2 ff ff       	call   8010325c <cpuid>
80104fb8:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80104fbc:	89 74 24 08          	mov    %esi,0x8(%esp)
80104fc0:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fc4:	c7 04 24 b8 73 10 80 	movl   $0x801073b8,(%esp)
80104fcb:	e8 e4 b5 ff ff       	call   801005b4 <cprintf>
    lapiceoi();
80104fd0:	e8 a3 d4 ff ff       	call   80102478 <lapiceoi>
    break;
80104fd5:	e9 52 ff ff ff       	jmp    80104f2c <trap+0xac>
80104fda:	66 90                	xchg   %ax,%ax
    uartintr();
80104fdc:	e8 fb 01 00 00       	call   801051dc <uartintr>
    lapiceoi();
80104fe1:	e8 92 d4 ff ff       	call   80102478 <lapiceoi>
    break;
80104fe6:	e9 41 ff ff ff       	jmp    80104f2c <trap+0xac>
80104feb:	90                   	nop
    kbdintr();
80104fec:	e8 13 d3 ff ff       	call   80102304 <kbdintr>
    lapiceoi();
80104ff1:	e8 82 d4 ff ff       	call   80102478 <lapiceoi>
    break;
80104ff6:	e9 31 ff ff ff       	jmp    80104f2c <trap+0xac>
80104ffb:	90                   	nop
    if(cpuid() == 0){
80104ffc:	e8 5b e2 ff ff       	call   8010325c <cpuid>
80105001:	85 c0                	test   %eax,%eax
80105003:	75 a0                	jne    80104fa5 <trap+0x125>
      acquire(&tickslock);
80105005:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
8010500c:	e8 6f ec ff ff       	call   80103c80 <acquire>
      ticks++;
80105011:	ff 05 a0 57 11 80    	incl   0x801157a0
      wakeup(&ticks);
80105017:	c7 04 24 a0 57 11 80 	movl   $0x801157a0,(%esp)
8010501e:	e8 19 e9 ff ff       	call   8010393c <wakeup>
      release(&tickslock);
80105023:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
8010502a:	e8 0d ed ff ff       	call   80103d3c <release>
8010502f:	e9 71 ff ff ff       	jmp    80104fa5 <trap+0x125>
  if(myproc() && myproc()->state == RUNNING &&
80105034:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105038:	0f 85 2b ff ff ff    	jne    80104f69 <trap+0xe9>
    if(MLFQ_tick_adder()){
8010503e:	e8 95 1a 00 00       	call   80106ad8 <MLFQ_tick_adder>
80105043:	85 c0                	test   %eax,%eax
80105045:	0f 84 1e ff ff ff    	je     80104f69 <trap+0xe9>
      yield();
8010504b:	e8 38 e7 ff ff       	call   80103788 <yield>
80105050:	e9 14 ff ff ff       	jmp    80104f69 <trap+0xe9>
80105055:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105058:	e8 33 e2 ff ff       	call   80103290 <myproc>
8010505d:	8b 70 24             	mov    0x24(%eax),%esi
80105060:	85 f6                	test   %esi,%esi
80105062:	75 38                	jne    8010509c <trap+0x21c>
    myproc()->tf = tf;
80105064:	e8 27 e2 ff ff       	call   80103290 <myproc>
80105069:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010506c:	e8 37 f0 ff ff       	call   801040a8 <syscall>
    if(myproc()->killed)
80105071:	e8 1a e2 ff ff       	call   80103290 <myproc>
80105076:	8b 48 24             	mov    0x24(%eax),%ecx
80105079:	85 c9                	test   %ecx,%ecx
8010507b:	0f 84 0d ff ff ff    	je     80104f8e <trap+0x10e>
}
80105081:	83 c4 3c             	add    $0x3c,%esp
80105084:	5b                   	pop    %ebx
80105085:	5e                   	pop    %esi
80105086:	5f                   	pop    %edi
80105087:	5d                   	pop    %ebp
      exit();
80105088:	e9 a3 e5 ff ff       	jmp    80103630 <exit>
8010508d:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
80105090:	e8 9b e5 ff ff       	call   80103630 <exit>
80105095:	e9 b7 fe ff ff       	jmp    80104f51 <trap+0xd1>
8010509a:	66 90                	xchg   %ax,%ax
      exit();
8010509c:	e8 8f e5 ff ff       	call   80103630 <exit>
801050a1:	eb c1                	jmp    80105064 <trap+0x1e4>
801050a3:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801050a6:	8b 73 38             	mov    0x38(%ebx),%esi
801050a9:	e8 ae e1 ff ff       	call   8010325c <cpuid>
801050ae:	89 7c 24 10          	mov    %edi,0x10(%esp)
801050b2:	89 74 24 0c          	mov    %esi,0xc(%esp)
801050b6:	89 44 24 08          	mov    %eax,0x8(%esp)
801050ba:	8b 43 30             	mov    0x30(%ebx),%eax
801050bd:	89 44 24 04          	mov    %eax,0x4(%esp)
801050c1:	c7 04 24 dc 73 10 80 	movl   $0x801073dc,(%esp)
801050c8:	e8 e7 b4 ff ff       	call   801005b4 <cprintf>
      panic("trap");
801050cd:	c7 04 24 b2 73 10 80 	movl   $0x801073b2,(%esp)
801050d4:	e8 37 b2 ff ff       	call   80100310 <panic>
801050d9:	66 90                	xchg   %ax,%ax
801050db:	90                   	nop

801050dc <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801050dc:	55                   	push   %ebp
801050dd:	89 e5                	mov    %esp,%ebp
  if(!uart)
801050df:	a1 a4 a5 10 80       	mov    0x8010a5a4,%eax
801050e4:	85 c0                	test   %eax,%eax
801050e6:	74 14                	je     801050fc <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801050e8:	ba fd 03 00 00       	mov    $0x3fd,%edx
801050ed:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801050ee:	a8 01                	test   $0x1,%al
801050f0:	74 0a                	je     801050fc <uartgetc+0x20>
801050f2:	b2 f8                	mov    $0xf8,%dl
801050f4:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801050f5:	0f b6 c0             	movzbl %al,%eax
}
801050f8:	5d                   	pop    %ebp
801050f9:	c3                   	ret    
801050fa:	66 90                	xchg   %ax,%ax
    return -1;
801050fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105101:	5d                   	pop    %ebp
80105102:	c3                   	ret    
80105103:	90                   	nop

80105104 <uartputc>:
  if(!uart)
80105104:	8b 15 a4 a5 10 80    	mov    0x8010a5a4,%edx
8010510a:	85 d2                	test   %edx,%edx
8010510c:	74 3c                	je     8010514a <uartputc+0x46>
{
8010510e:	55                   	push   %ebp
8010510f:	89 e5                	mov    %esp,%ebp
80105111:	56                   	push   %esi
80105112:	53                   	push   %ebx
80105113:	83 ec 10             	sub    $0x10,%esp
  if(!uart)
80105116:	bb 80 00 00 00       	mov    $0x80,%ebx
8010511b:	be fd 03 00 00       	mov    $0x3fd,%esi
80105120:	eb 11                	jmp    80105133 <uartputc+0x2f>
80105122:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105124:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
8010512b:	e8 64 d3 ff ff       	call   80102494 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105130:	4b                   	dec    %ebx
80105131:	74 07                	je     8010513a <uartputc+0x36>
80105133:	89 f2                	mov    %esi,%edx
80105135:	ec                   	in     (%dx),%al
80105136:	a8 20                	test   $0x20,%al
80105138:	74 ea                	je     80105124 <uartputc+0x20>
  outb(COM1+0, c);
8010513a:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010513e:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105143:	ee                   	out    %al,(%dx)
}
80105144:	83 c4 10             	add    $0x10,%esp
80105147:	5b                   	pop    %ebx
80105148:	5e                   	pop    %esi
80105149:	5d                   	pop    %ebp
8010514a:	c3                   	ret    
8010514b:	90                   	nop

8010514c <uartinit>:
{
8010514c:	55                   	push   %ebp
8010514d:	89 e5                	mov    %esp,%ebp
8010514f:	57                   	push   %edi
80105150:	56                   	push   %esi
80105151:	53                   	push   %ebx
80105152:	83 ec 1c             	sub    $0x1c,%esp
80105155:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010515a:	31 c0                	xor    %eax,%eax
8010515c:	89 fa                	mov    %edi,%edx
8010515e:	ee                   	out    %al,(%dx)
8010515f:	bb fb 03 00 00       	mov    $0x3fb,%ebx
80105164:	b0 80                	mov    $0x80,%al
80105166:	89 da                	mov    %ebx,%edx
80105168:	ee                   	out    %al,(%dx)
80105169:	be f8 03 00 00       	mov    $0x3f8,%esi
8010516e:	b0 0c                	mov    $0xc,%al
80105170:	89 f2                	mov    %esi,%edx
80105172:	ee                   	out    %al,(%dx)
80105173:	b9 f9 03 00 00       	mov    $0x3f9,%ecx
80105178:	31 c0                	xor    %eax,%eax
8010517a:	89 ca                	mov    %ecx,%edx
8010517c:	ee                   	out    %al,(%dx)
8010517d:	b0 03                	mov    $0x3,%al
8010517f:	89 da                	mov    %ebx,%edx
80105181:	ee                   	out    %al,(%dx)
80105182:	b2 fc                	mov    $0xfc,%dl
80105184:	31 c0                	xor    %eax,%eax
80105186:	ee                   	out    %al,(%dx)
80105187:	b0 01                	mov    $0x1,%al
80105189:	89 ca                	mov    %ecx,%edx
8010518b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010518c:	b2 fd                	mov    $0xfd,%dl
8010518e:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
8010518f:	fe c0                	inc    %al
80105191:	74 41                	je     801051d4 <uartinit+0x88>
  uart = 1;
80105193:	c7 05 a4 a5 10 80 01 	movl   $0x1,0x8010a5a4
8010519a:	00 00 00 
8010519d:	89 fa                	mov    %edi,%edx
8010519f:	ec                   	in     (%dx),%al
801051a0:	89 f2                	mov    %esi,%edx
801051a2:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801051a3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801051aa:	00 
801051ab:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801051b2:	e8 c5 ce ff ff       	call   8010207c <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801051b7:	b8 78 00 00 00       	mov    $0x78,%eax
801051bc:	bb d4 74 10 80       	mov    $0x801074d4,%ebx
801051c1:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(*p);
801051c4:	89 04 24             	mov    %eax,(%esp)
801051c7:	e8 38 ff ff ff       	call   80105104 <uartputc>
  for(p="xv6...\n"; *p; p++)
801051cc:	43                   	inc    %ebx
801051cd:	0f be 03             	movsbl (%ebx),%eax
801051d0:	84 c0                	test   %al,%al
801051d2:	75 f0                	jne    801051c4 <uartinit+0x78>
}
801051d4:	83 c4 1c             	add    $0x1c,%esp
801051d7:	5b                   	pop    %ebx
801051d8:	5e                   	pop    %esi
801051d9:	5f                   	pop    %edi
801051da:	5d                   	pop    %ebp
801051db:	c3                   	ret    

801051dc <uartintr>:

void
uartintr(void)
{
801051dc:	55                   	push   %ebp
801051dd:	89 e5                	mov    %esp,%ebp
801051df:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801051e2:	c7 04 24 dc 50 10 80 	movl   $0x801050dc,(%esp)
801051e9:	e8 12 b5 ff ff       	call   80100700 <consoleintr>
}
801051ee:	c9                   	leave  
801051ef:	c3                   	ret    

801051f0 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801051f0:	6a 00                	push   $0x0
  pushl $0
801051f2:	6a 00                	push   $0x0
  jmp alltraps
801051f4:	e9 b8 fb ff ff       	jmp    80104db1 <alltraps>

801051f9 <vector1>:
.globl vector1
vector1:
  pushl $0
801051f9:	6a 00                	push   $0x0
  pushl $1
801051fb:	6a 01                	push   $0x1
  jmp alltraps
801051fd:	e9 af fb ff ff       	jmp    80104db1 <alltraps>

80105202 <vector2>:
.globl vector2
vector2:
  pushl $0
80105202:	6a 00                	push   $0x0
  pushl $2
80105204:	6a 02                	push   $0x2
  jmp alltraps
80105206:	e9 a6 fb ff ff       	jmp    80104db1 <alltraps>

8010520b <vector3>:
.globl vector3
vector3:
  pushl $0
8010520b:	6a 00                	push   $0x0
  pushl $3
8010520d:	6a 03                	push   $0x3
  jmp alltraps
8010520f:	e9 9d fb ff ff       	jmp    80104db1 <alltraps>

80105214 <vector4>:
.globl vector4
vector4:
  pushl $0
80105214:	6a 00                	push   $0x0
  pushl $4
80105216:	6a 04                	push   $0x4
  jmp alltraps
80105218:	e9 94 fb ff ff       	jmp    80104db1 <alltraps>

8010521d <vector5>:
.globl vector5
vector5:
  pushl $0
8010521d:	6a 00                	push   $0x0
  pushl $5
8010521f:	6a 05                	push   $0x5
  jmp alltraps
80105221:	e9 8b fb ff ff       	jmp    80104db1 <alltraps>

80105226 <vector6>:
.globl vector6
vector6:
  pushl $0
80105226:	6a 00                	push   $0x0
  pushl $6
80105228:	6a 06                	push   $0x6
  jmp alltraps
8010522a:	e9 82 fb ff ff       	jmp    80104db1 <alltraps>

8010522f <vector7>:
.globl vector7
vector7:
  pushl $0
8010522f:	6a 00                	push   $0x0
  pushl $7
80105231:	6a 07                	push   $0x7
  jmp alltraps
80105233:	e9 79 fb ff ff       	jmp    80104db1 <alltraps>

80105238 <vector8>:
.globl vector8
vector8:
  pushl $8
80105238:	6a 08                	push   $0x8
  jmp alltraps
8010523a:	e9 72 fb ff ff       	jmp    80104db1 <alltraps>

8010523f <vector9>:
.globl vector9
vector9:
  pushl $0
8010523f:	6a 00                	push   $0x0
  pushl $9
80105241:	6a 09                	push   $0x9
  jmp alltraps
80105243:	e9 69 fb ff ff       	jmp    80104db1 <alltraps>

80105248 <vector10>:
.globl vector10
vector10:
  pushl $10
80105248:	6a 0a                	push   $0xa
  jmp alltraps
8010524a:	e9 62 fb ff ff       	jmp    80104db1 <alltraps>

8010524f <vector11>:
.globl vector11
vector11:
  pushl $11
8010524f:	6a 0b                	push   $0xb
  jmp alltraps
80105251:	e9 5b fb ff ff       	jmp    80104db1 <alltraps>

80105256 <vector12>:
.globl vector12
vector12:
  pushl $12
80105256:	6a 0c                	push   $0xc
  jmp alltraps
80105258:	e9 54 fb ff ff       	jmp    80104db1 <alltraps>

8010525d <vector13>:
.globl vector13
vector13:
  pushl $13
8010525d:	6a 0d                	push   $0xd
  jmp alltraps
8010525f:	e9 4d fb ff ff       	jmp    80104db1 <alltraps>

80105264 <vector14>:
.globl vector14
vector14:
  pushl $14
80105264:	6a 0e                	push   $0xe
  jmp alltraps
80105266:	e9 46 fb ff ff       	jmp    80104db1 <alltraps>

8010526b <vector15>:
.globl vector15
vector15:
  pushl $0
8010526b:	6a 00                	push   $0x0
  pushl $15
8010526d:	6a 0f                	push   $0xf
  jmp alltraps
8010526f:	e9 3d fb ff ff       	jmp    80104db1 <alltraps>

80105274 <vector16>:
.globl vector16
vector16:
  pushl $0
80105274:	6a 00                	push   $0x0
  pushl $16
80105276:	6a 10                	push   $0x10
  jmp alltraps
80105278:	e9 34 fb ff ff       	jmp    80104db1 <alltraps>

8010527d <vector17>:
.globl vector17
vector17:
  pushl $17
8010527d:	6a 11                	push   $0x11
  jmp alltraps
8010527f:	e9 2d fb ff ff       	jmp    80104db1 <alltraps>

80105284 <vector18>:
.globl vector18
vector18:
  pushl $0
80105284:	6a 00                	push   $0x0
  pushl $18
80105286:	6a 12                	push   $0x12
  jmp alltraps
80105288:	e9 24 fb ff ff       	jmp    80104db1 <alltraps>

8010528d <vector19>:
.globl vector19
vector19:
  pushl $0
8010528d:	6a 00                	push   $0x0
  pushl $19
8010528f:	6a 13                	push   $0x13
  jmp alltraps
80105291:	e9 1b fb ff ff       	jmp    80104db1 <alltraps>

80105296 <vector20>:
.globl vector20
vector20:
  pushl $0
80105296:	6a 00                	push   $0x0
  pushl $20
80105298:	6a 14                	push   $0x14
  jmp alltraps
8010529a:	e9 12 fb ff ff       	jmp    80104db1 <alltraps>

8010529f <vector21>:
.globl vector21
vector21:
  pushl $0
8010529f:	6a 00                	push   $0x0
  pushl $21
801052a1:	6a 15                	push   $0x15
  jmp alltraps
801052a3:	e9 09 fb ff ff       	jmp    80104db1 <alltraps>

801052a8 <vector22>:
.globl vector22
vector22:
  pushl $0
801052a8:	6a 00                	push   $0x0
  pushl $22
801052aa:	6a 16                	push   $0x16
  jmp alltraps
801052ac:	e9 00 fb ff ff       	jmp    80104db1 <alltraps>

801052b1 <vector23>:
.globl vector23
vector23:
  pushl $0
801052b1:	6a 00                	push   $0x0
  pushl $23
801052b3:	6a 17                	push   $0x17
  jmp alltraps
801052b5:	e9 f7 fa ff ff       	jmp    80104db1 <alltraps>

801052ba <vector24>:
.globl vector24
vector24:
  pushl $0
801052ba:	6a 00                	push   $0x0
  pushl $24
801052bc:	6a 18                	push   $0x18
  jmp alltraps
801052be:	e9 ee fa ff ff       	jmp    80104db1 <alltraps>

801052c3 <vector25>:
.globl vector25
vector25:
  pushl $0
801052c3:	6a 00                	push   $0x0
  pushl $25
801052c5:	6a 19                	push   $0x19
  jmp alltraps
801052c7:	e9 e5 fa ff ff       	jmp    80104db1 <alltraps>

801052cc <vector26>:
.globl vector26
vector26:
  pushl $0
801052cc:	6a 00                	push   $0x0
  pushl $26
801052ce:	6a 1a                	push   $0x1a
  jmp alltraps
801052d0:	e9 dc fa ff ff       	jmp    80104db1 <alltraps>

801052d5 <vector27>:
.globl vector27
vector27:
  pushl $0
801052d5:	6a 00                	push   $0x0
  pushl $27
801052d7:	6a 1b                	push   $0x1b
  jmp alltraps
801052d9:	e9 d3 fa ff ff       	jmp    80104db1 <alltraps>

801052de <vector28>:
.globl vector28
vector28:
  pushl $0
801052de:	6a 00                	push   $0x0
  pushl $28
801052e0:	6a 1c                	push   $0x1c
  jmp alltraps
801052e2:	e9 ca fa ff ff       	jmp    80104db1 <alltraps>

801052e7 <vector29>:
.globl vector29
vector29:
  pushl $0
801052e7:	6a 00                	push   $0x0
  pushl $29
801052e9:	6a 1d                	push   $0x1d
  jmp alltraps
801052eb:	e9 c1 fa ff ff       	jmp    80104db1 <alltraps>

801052f0 <vector30>:
.globl vector30
vector30:
  pushl $0
801052f0:	6a 00                	push   $0x0
  pushl $30
801052f2:	6a 1e                	push   $0x1e
  jmp alltraps
801052f4:	e9 b8 fa ff ff       	jmp    80104db1 <alltraps>

801052f9 <vector31>:
.globl vector31
vector31:
  pushl $0
801052f9:	6a 00                	push   $0x0
  pushl $31
801052fb:	6a 1f                	push   $0x1f
  jmp alltraps
801052fd:	e9 af fa ff ff       	jmp    80104db1 <alltraps>

80105302 <vector32>:
.globl vector32
vector32:
  pushl $0
80105302:	6a 00                	push   $0x0
  pushl $32
80105304:	6a 20                	push   $0x20
  jmp alltraps
80105306:	e9 a6 fa ff ff       	jmp    80104db1 <alltraps>

8010530b <vector33>:
.globl vector33
vector33:
  pushl $0
8010530b:	6a 00                	push   $0x0
  pushl $33
8010530d:	6a 21                	push   $0x21
  jmp alltraps
8010530f:	e9 9d fa ff ff       	jmp    80104db1 <alltraps>

80105314 <vector34>:
.globl vector34
vector34:
  pushl $0
80105314:	6a 00                	push   $0x0
  pushl $34
80105316:	6a 22                	push   $0x22
  jmp alltraps
80105318:	e9 94 fa ff ff       	jmp    80104db1 <alltraps>

8010531d <vector35>:
.globl vector35
vector35:
  pushl $0
8010531d:	6a 00                	push   $0x0
  pushl $35
8010531f:	6a 23                	push   $0x23
  jmp alltraps
80105321:	e9 8b fa ff ff       	jmp    80104db1 <alltraps>

80105326 <vector36>:
.globl vector36
vector36:
  pushl $0
80105326:	6a 00                	push   $0x0
  pushl $36
80105328:	6a 24                	push   $0x24
  jmp alltraps
8010532a:	e9 82 fa ff ff       	jmp    80104db1 <alltraps>

8010532f <vector37>:
.globl vector37
vector37:
  pushl $0
8010532f:	6a 00                	push   $0x0
  pushl $37
80105331:	6a 25                	push   $0x25
  jmp alltraps
80105333:	e9 79 fa ff ff       	jmp    80104db1 <alltraps>

80105338 <vector38>:
.globl vector38
vector38:
  pushl $0
80105338:	6a 00                	push   $0x0
  pushl $38
8010533a:	6a 26                	push   $0x26
  jmp alltraps
8010533c:	e9 70 fa ff ff       	jmp    80104db1 <alltraps>

80105341 <vector39>:
.globl vector39
vector39:
  pushl $0
80105341:	6a 00                	push   $0x0
  pushl $39
80105343:	6a 27                	push   $0x27
  jmp alltraps
80105345:	e9 67 fa ff ff       	jmp    80104db1 <alltraps>

8010534a <vector40>:
.globl vector40
vector40:
  pushl $0
8010534a:	6a 00                	push   $0x0
  pushl $40
8010534c:	6a 28                	push   $0x28
  jmp alltraps
8010534e:	e9 5e fa ff ff       	jmp    80104db1 <alltraps>

80105353 <vector41>:
.globl vector41
vector41:
  pushl $0
80105353:	6a 00                	push   $0x0
  pushl $41
80105355:	6a 29                	push   $0x29
  jmp alltraps
80105357:	e9 55 fa ff ff       	jmp    80104db1 <alltraps>

8010535c <vector42>:
.globl vector42
vector42:
  pushl $0
8010535c:	6a 00                	push   $0x0
  pushl $42
8010535e:	6a 2a                	push   $0x2a
  jmp alltraps
80105360:	e9 4c fa ff ff       	jmp    80104db1 <alltraps>

80105365 <vector43>:
.globl vector43
vector43:
  pushl $0
80105365:	6a 00                	push   $0x0
  pushl $43
80105367:	6a 2b                	push   $0x2b
  jmp alltraps
80105369:	e9 43 fa ff ff       	jmp    80104db1 <alltraps>

8010536e <vector44>:
.globl vector44
vector44:
  pushl $0
8010536e:	6a 00                	push   $0x0
  pushl $44
80105370:	6a 2c                	push   $0x2c
  jmp alltraps
80105372:	e9 3a fa ff ff       	jmp    80104db1 <alltraps>

80105377 <vector45>:
.globl vector45
vector45:
  pushl $0
80105377:	6a 00                	push   $0x0
  pushl $45
80105379:	6a 2d                	push   $0x2d
  jmp alltraps
8010537b:	e9 31 fa ff ff       	jmp    80104db1 <alltraps>

80105380 <vector46>:
.globl vector46
vector46:
  pushl $0
80105380:	6a 00                	push   $0x0
  pushl $46
80105382:	6a 2e                	push   $0x2e
  jmp alltraps
80105384:	e9 28 fa ff ff       	jmp    80104db1 <alltraps>

80105389 <vector47>:
.globl vector47
vector47:
  pushl $0
80105389:	6a 00                	push   $0x0
  pushl $47
8010538b:	6a 2f                	push   $0x2f
  jmp alltraps
8010538d:	e9 1f fa ff ff       	jmp    80104db1 <alltraps>

80105392 <vector48>:
.globl vector48
vector48:
  pushl $0
80105392:	6a 00                	push   $0x0
  pushl $48
80105394:	6a 30                	push   $0x30
  jmp alltraps
80105396:	e9 16 fa ff ff       	jmp    80104db1 <alltraps>

8010539b <vector49>:
.globl vector49
vector49:
  pushl $0
8010539b:	6a 00                	push   $0x0
  pushl $49
8010539d:	6a 31                	push   $0x31
  jmp alltraps
8010539f:	e9 0d fa ff ff       	jmp    80104db1 <alltraps>

801053a4 <vector50>:
.globl vector50
vector50:
  pushl $0
801053a4:	6a 00                	push   $0x0
  pushl $50
801053a6:	6a 32                	push   $0x32
  jmp alltraps
801053a8:	e9 04 fa ff ff       	jmp    80104db1 <alltraps>

801053ad <vector51>:
.globl vector51
vector51:
  pushl $0
801053ad:	6a 00                	push   $0x0
  pushl $51
801053af:	6a 33                	push   $0x33
  jmp alltraps
801053b1:	e9 fb f9 ff ff       	jmp    80104db1 <alltraps>

801053b6 <vector52>:
.globl vector52
vector52:
  pushl $0
801053b6:	6a 00                	push   $0x0
  pushl $52
801053b8:	6a 34                	push   $0x34
  jmp alltraps
801053ba:	e9 f2 f9 ff ff       	jmp    80104db1 <alltraps>

801053bf <vector53>:
.globl vector53
vector53:
  pushl $0
801053bf:	6a 00                	push   $0x0
  pushl $53
801053c1:	6a 35                	push   $0x35
  jmp alltraps
801053c3:	e9 e9 f9 ff ff       	jmp    80104db1 <alltraps>

801053c8 <vector54>:
.globl vector54
vector54:
  pushl $0
801053c8:	6a 00                	push   $0x0
  pushl $54
801053ca:	6a 36                	push   $0x36
  jmp alltraps
801053cc:	e9 e0 f9 ff ff       	jmp    80104db1 <alltraps>

801053d1 <vector55>:
.globl vector55
vector55:
  pushl $0
801053d1:	6a 00                	push   $0x0
  pushl $55
801053d3:	6a 37                	push   $0x37
  jmp alltraps
801053d5:	e9 d7 f9 ff ff       	jmp    80104db1 <alltraps>

801053da <vector56>:
.globl vector56
vector56:
  pushl $0
801053da:	6a 00                	push   $0x0
  pushl $56
801053dc:	6a 38                	push   $0x38
  jmp alltraps
801053de:	e9 ce f9 ff ff       	jmp    80104db1 <alltraps>

801053e3 <vector57>:
.globl vector57
vector57:
  pushl $0
801053e3:	6a 00                	push   $0x0
  pushl $57
801053e5:	6a 39                	push   $0x39
  jmp alltraps
801053e7:	e9 c5 f9 ff ff       	jmp    80104db1 <alltraps>

801053ec <vector58>:
.globl vector58
vector58:
  pushl $0
801053ec:	6a 00                	push   $0x0
  pushl $58
801053ee:	6a 3a                	push   $0x3a
  jmp alltraps
801053f0:	e9 bc f9 ff ff       	jmp    80104db1 <alltraps>

801053f5 <vector59>:
.globl vector59
vector59:
  pushl $0
801053f5:	6a 00                	push   $0x0
  pushl $59
801053f7:	6a 3b                	push   $0x3b
  jmp alltraps
801053f9:	e9 b3 f9 ff ff       	jmp    80104db1 <alltraps>

801053fe <vector60>:
.globl vector60
vector60:
  pushl $0
801053fe:	6a 00                	push   $0x0
  pushl $60
80105400:	6a 3c                	push   $0x3c
  jmp alltraps
80105402:	e9 aa f9 ff ff       	jmp    80104db1 <alltraps>

80105407 <vector61>:
.globl vector61
vector61:
  pushl $0
80105407:	6a 00                	push   $0x0
  pushl $61
80105409:	6a 3d                	push   $0x3d
  jmp alltraps
8010540b:	e9 a1 f9 ff ff       	jmp    80104db1 <alltraps>

80105410 <vector62>:
.globl vector62
vector62:
  pushl $0
80105410:	6a 00                	push   $0x0
  pushl $62
80105412:	6a 3e                	push   $0x3e
  jmp alltraps
80105414:	e9 98 f9 ff ff       	jmp    80104db1 <alltraps>

80105419 <vector63>:
.globl vector63
vector63:
  pushl $0
80105419:	6a 00                	push   $0x0
  pushl $63
8010541b:	6a 3f                	push   $0x3f
  jmp alltraps
8010541d:	e9 8f f9 ff ff       	jmp    80104db1 <alltraps>

80105422 <vector64>:
.globl vector64
vector64:
  pushl $0
80105422:	6a 00                	push   $0x0
  pushl $64
80105424:	6a 40                	push   $0x40
  jmp alltraps
80105426:	e9 86 f9 ff ff       	jmp    80104db1 <alltraps>

8010542b <vector65>:
.globl vector65
vector65:
  pushl $0
8010542b:	6a 00                	push   $0x0
  pushl $65
8010542d:	6a 41                	push   $0x41
  jmp alltraps
8010542f:	e9 7d f9 ff ff       	jmp    80104db1 <alltraps>

80105434 <vector66>:
.globl vector66
vector66:
  pushl $0
80105434:	6a 00                	push   $0x0
  pushl $66
80105436:	6a 42                	push   $0x42
  jmp alltraps
80105438:	e9 74 f9 ff ff       	jmp    80104db1 <alltraps>

8010543d <vector67>:
.globl vector67
vector67:
  pushl $0
8010543d:	6a 00                	push   $0x0
  pushl $67
8010543f:	6a 43                	push   $0x43
  jmp alltraps
80105441:	e9 6b f9 ff ff       	jmp    80104db1 <alltraps>

80105446 <vector68>:
.globl vector68
vector68:
  pushl $0
80105446:	6a 00                	push   $0x0
  pushl $68
80105448:	6a 44                	push   $0x44
  jmp alltraps
8010544a:	e9 62 f9 ff ff       	jmp    80104db1 <alltraps>

8010544f <vector69>:
.globl vector69
vector69:
  pushl $0
8010544f:	6a 00                	push   $0x0
  pushl $69
80105451:	6a 45                	push   $0x45
  jmp alltraps
80105453:	e9 59 f9 ff ff       	jmp    80104db1 <alltraps>

80105458 <vector70>:
.globl vector70
vector70:
  pushl $0
80105458:	6a 00                	push   $0x0
  pushl $70
8010545a:	6a 46                	push   $0x46
  jmp alltraps
8010545c:	e9 50 f9 ff ff       	jmp    80104db1 <alltraps>

80105461 <vector71>:
.globl vector71
vector71:
  pushl $0
80105461:	6a 00                	push   $0x0
  pushl $71
80105463:	6a 47                	push   $0x47
  jmp alltraps
80105465:	e9 47 f9 ff ff       	jmp    80104db1 <alltraps>

8010546a <vector72>:
.globl vector72
vector72:
  pushl $0
8010546a:	6a 00                	push   $0x0
  pushl $72
8010546c:	6a 48                	push   $0x48
  jmp alltraps
8010546e:	e9 3e f9 ff ff       	jmp    80104db1 <alltraps>

80105473 <vector73>:
.globl vector73
vector73:
  pushl $0
80105473:	6a 00                	push   $0x0
  pushl $73
80105475:	6a 49                	push   $0x49
  jmp alltraps
80105477:	e9 35 f9 ff ff       	jmp    80104db1 <alltraps>

8010547c <vector74>:
.globl vector74
vector74:
  pushl $0
8010547c:	6a 00                	push   $0x0
  pushl $74
8010547e:	6a 4a                	push   $0x4a
  jmp alltraps
80105480:	e9 2c f9 ff ff       	jmp    80104db1 <alltraps>

80105485 <vector75>:
.globl vector75
vector75:
  pushl $0
80105485:	6a 00                	push   $0x0
  pushl $75
80105487:	6a 4b                	push   $0x4b
  jmp alltraps
80105489:	e9 23 f9 ff ff       	jmp    80104db1 <alltraps>

8010548e <vector76>:
.globl vector76
vector76:
  pushl $0
8010548e:	6a 00                	push   $0x0
  pushl $76
80105490:	6a 4c                	push   $0x4c
  jmp alltraps
80105492:	e9 1a f9 ff ff       	jmp    80104db1 <alltraps>

80105497 <vector77>:
.globl vector77
vector77:
  pushl $0
80105497:	6a 00                	push   $0x0
  pushl $77
80105499:	6a 4d                	push   $0x4d
  jmp alltraps
8010549b:	e9 11 f9 ff ff       	jmp    80104db1 <alltraps>

801054a0 <vector78>:
.globl vector78
vector78:
  pushl $0
801054a0:	6a 00                	push   $0x0
  pushl $78
801054a2:	6a 4e                	push   $0x4e
  jmp alltraps
801054a4:	e9 08 f9 ff ff       	jmp    80104db1 <alltraps>

801054a9 <vector79>:
.globl vector79
vector79:
  pushl $0
801054a9:	6a 00                	push   $0x0
  pushl $79
801054ab:	6a 4f                	push   $0x4f
  jmp alltraps
801054ad:	e9 ff f8 ff ff       	jmp    80104db1 <alltraps>

801054b2 <vector80>:
.globl vector80
vector80:
  pushl $0
801054b2:	6a 00                	push   $0x0
  pushl $80
801054b4:	6a 50                	push   $0x50
  jmp alltraps
801054b6:	e9 f6 f8 ff ff       	jmp    80104db1 <alltraps>

801054bb <vector81>:
.globl vector81
vector81:
  pushl $0
801054bb:	6a 00                	push   $0x0
  pushl $81
801054bd:	6a 51                	push   $0x51
  jmp alltraps
801054bf:	e9 ed f8 ff ff       	jmp    80104db1 <alltraps>

801054c4 <vector82>:
.globl vector82
vector82:
  pushl $0
801054c4:	6a 00                	push   $0x0
  pushl $82
801054c6:	6a 52                	push   $0x52
  jmp alltraps
801054c8:	e9 e4 f8 ff ff       	jmp    80104db1 <alltraps>

801054cd <vector83>:
.globl vector83
vector83:
  pushl $0
801054cd:	6a 00                	push   $0x0
  pushl $83
801054cf:	6a 53                	push   $0x53
  jmp alltraps
801054d1:	e9 db f8 ff ff       	jmp    80104db1 <alltraps>

801054d6 <vector84>:
.globl vector84
vector84:
  pushl $0
801054d6:	6a 00                	push   $0x0
  pushl $84
801054d8:	6a 54                	push   $0x54
  jmp alltraps
801054da:	e9 d2 f8 ff ff       	jmp    80104db1 <alltraps>

801054df <vector85>:
.globl vector85
vector85:
  pushl $0
801054df:	6a 00                	push   $0x0
  pushl $85
801054e1:	6a 55                	push   $0x55
  jmp alltraps
801054e3:	e9 c9 f8 ff ff       	jmp    80104db1 <alltraps>

801054e8 <vector86>:
.globl vector86
vector86:
  pushl $0
801054e8:	6a 00                	push   $0x0
  pushl $86
801054ea:	6a 56                	push   $0x56
  jmp alltraps
801054ec:	e9 c0 f8 ff ff       	jmp    80104db1 <alltraps>

801054f1 <vector87>:
.globl vector87
vector87:
  pushl $0
801054f1:	6a 00                	push   $0x0
  pushl $87
801054f3:	6a 57                	push   $0x57
  jmp alltraps
801054f5:	e9 b7 f8 ff ff       	jmp    80104db1 <alltraps>

801054fa <vector88>:
.globl vector88
vector88:
  pushl $0
801054fa:	6a 00                	push   $0x0
  pushl $88
801054fc:	6a 58                	push   $0x58
  jmp alltraps
801054fe:	e9 ae f8 ff ff       	jmp    80104db1 <alltraps>

80105503 <vector89>:
.globl vector89
vector89:
  pushl $0
80105503:	6a 00                	push   $0x0
  pushl $89
80105505:	6a 59                	push   $0x59
  jmp alltraps
80105507:	e9 a5 f8 ff ff       	jmp    80104db1 <alltraps>

8010550c <vector90>:
.globl vector90
vector90:
  pushl $0
8010550c:	6a 00                	push   $0x0
  pushl $90
8010550e:	6a 5a                	push   $0x5a
  jmp alltraps
80105510:	e9 9c f8 ff ff       	jmp    80104db1 <alltraps>

80105515 <vector91>:
.globl vector91
vector91:
  pushl $0
80105515:	6a 00                	push   $0x0
  pushl $91
80105517:	6a 5b                	push   $0x5b
  jmp alltraps
80105519:	e9 93 f8 ff ff       	jmp    80104db1 <alltraps>

8010551e <vector92>:
.globl vector92
vector92:
  pushl $0
8010551e:	6a 00                	push   $0x0
  pushl $92
80105520:	6a 5c                	push   $0x5c
  jmp alltraps
80105522:	e9 8a f8 ff ff       	jmp    80104db1 <alltraps>

80105527 <vector93>:
.globl vector93
vector93:
  pushl $0
80105527:	6a 00                	push   $0x0
  pushl $93
80105529:	6a 5d                	push   $0x5d
  jmp alltraps
8010552b:	e9 81 f8 ff ff       	jmp    80104db1 <alltraps>

80105530 <vector94>:
.globl vector94
vector94:
  pushl $0
80105530:	6a 00                	push   $0x0
  pushl $94
80105532:	6a 5e                	push   $0x5e
  jmp alltraps
80105534:	e9 78 f8 ff ff       	jmp    80104db1 <alltraps>

80105539 <vector95>:
.globl vector95
vector95:
  pushl $0
80105539:	6a 00                	push   $0x0
  pushl $95
8010553b:	6a 5f                	push   $0x5f
  jmp alltraps
8010553d:	e9 6f f8 ff ff       	jmp    80104db1 <alltraps>

80105542 <vector96>:
.globl vector96
vector96:
  pushl $0
80105542:	6a 00                	push   $0x0
  pushl $96
80105544:	6a 60                	push   $0x60
  jmp alltraps
80105546:	e9 66 f8 ff ff       	jmp    80104db1 <alltraps>

8010554b <vector97>:
.globl vector97
vector97:
  pushl $0
8010554b:	6a 00                	push   $0x0
  pushl $97
8010554d:	6a 61                	push   $0x61
  jmp alltraps
8010554f:	e9 5d f8 ff ff       	jmp    80104db1 <alltraps>

80105554 <vector98>:
.globl vector98
vector98:
  pushl $0
80105554:	6a 00                	push   $0x0
  pushl $98
80105556:	6a 62                	push   $0x62
  jmp alltraps
80105558:	e9 54 f8 ff ff       	jmp    80104db1 <alltraps>

8010555d <vector99>:
.globl vector99
vector99:
  pushl $0
8010555d:	6a 00                	push   $0x0
  pushl $99
8010555f:	6a 63                	push   $0x63
  jmp alltraps
80105561:	e9 4b f8 ff ff       	jmp    80104db1 <alltraps>

80105566 <vector100>:
.globl vector100
vector100:
  pushl $0
80105566:	6a 00                	push   $0x0
  pushl $100
80105568:	6a 64                	push   $0x64
  jmp alltraps
8010556a:	e9 42 f8 ff ff       	jmp    80104db1 <alltraps>

8010556f <vector101>:
.globl vector101
vector101:
  pushl $0
8010556f:	6a 00                	push   $0x0
  pushl $101
80105571:	6a 65                	push   $0x65
  jmp alltraps
80105573:	e9 39 f8 ff ff       	jmp    80104db1 <alltraps>

80105578 <vector102>:
.globl vector102
vector102:
  pushl $0
80105578:	6a 00                	push   $0x0
  pushl $102
8010557a:	6a 66                	push   $0x66
  jmp alltraps
8010557c:	e9 30 f8 ff ff       	jmp    80104db1 <alltraps>

80105581 <vector103>:
.globl vector103
vector103:
  pushl $0
80105581:	6a 00                	push   $0x0
  pushl $103
80105583:	6a 67                	push   $0x67
  jmp alltraps
80105585:	e9 27 f8 ff ff       	jmp    80104db1 <alltraps>

8010558a <vector104>:
.globl vector104
vector104:
  pushl $0
8010558a:	6a 00                	push   $0x0
  pushl $104
8010558c:	6a 68                	push   $0x68
  jmp alltraps
8010558e:	e9 1e f8 ff ff       	jmp    80104db1 <alltraps>

80105593 <vector105>:
.globl vector105
vector105:
  pushl $0
80105593:	6a 00                	push   $0x0
  pushl $105
80105595:	6a 69                	push   $0x69
  jmp alltraps
80105597:	e9 15 f8 ff ff       	jmp    80104db1 <alltraps>

8010559c <vector106>:
.globl vector106
vector106:
  pushl $0
8010559c:	6a 00                	push   $0x0
  pushl $106
8010559e:	6a 6a                	push   $0x6a
  jmp alltraps
801055a0:	e9 0c f8 ff ff       	jmp    80104db1 <alltraps>

801055a5 <vector107>:
.globl vector107
vector107:
  pushl $0
801055a5:	6a 00                	push   $0x0
  pushl $107
801055a7:	6a 6b                	push   $0x6b
  jmp alltraps
801055a9:	e9 03 f8 ff ff       	jmp    80104db1 <alltraps>

801055ae <vector108>:
.globl vector108
vector108:
  pushl $0
801055ae:	6a 00                	push   $0x0
  pushl $108
801055b0:	6a 6c                	push   $0x6c
  jmp alltraps
801055b2:	e9 fa f7 ff ff       	jmp    80104db1 <alltraps>

801055b7 <vector109>:
.globl vector109
vector109:
  pushl $0
801055b7:	6a 00                	push   $0x0
  pushl $109
801055b9:	6a 6d                	push   $0x6d
  jmp alltraps
801055bb:	e9 f1 f7 ff ff       	jmp    80104db1 <alltraps>

801055c0 <vector110>:
.globl vector110
vector110:
  pushl $0
801055c0:	6a 00                	push   $0x0
  pushl $110
801055c2:	6a 6e                	push   $0x6e
  jmp alltraps
801055c4:	e9 e8 f7 ff ff       	jmp    80104db1 <alltraps>

801055c9 <vector111>:
.globl vector111
vector111:
  pushl $0
801055c9:	6a 00                	push   $0x0
  pushl $111
801055cb:	6a 6f                	push   $0x6f
  jmp alltraps
801055cd:	e9 df f7 ff ff       	jmp    80104db1 <alltraps>

801055d2 <vector112>:
.globl vector112
vector112:
  pushl $0
801055d2:	6a 00                	push   $0x0
  pushl $112
801055d4:	6a 70                	push   $0x70
  jmp alltraps
801055d6:	e9 d6 f7 ff ff       	jmp    80104db1 <alltraps>

801055db <vector113>:
.globl vector113
vector113:
  pushl $0
801055db:	6a 00                	push   $0x0
  pushl $113
801055dd:	6a 71                	push   $0x71
  jmp alltraps
801055df:	e9 cd f7 ff ff       	jmp    80104db1 <alltraps>

801055e4 <vector114>:
.globl vector114
vector114:
  pushl $0
801055e4:	6a 00                	push   $0x0
  pushl $114
801055e6:	6a 72                	push   $0x72
  jmp alltraps
801055e8:	e9 c4 f7 ff ff       	jmp    80104db1 <alltraps>

801055ed <vector115>:
.globl vector115
vector115:
  pushl $0
801055ed:	6a 00                	push   $0x0
  pushl $115
801055ef:	6a 73                	push   $0x73
  jmp alltraps
801055f1:	e9 bb f7 ff ff       	jmp    80104db1 <alltraps>

801055f6 <vector116>:
.globl vector116
vector116:
  pushl $0
801055f6:	6a 00                	push   $0x0
  pushl $116
801055f8:	6a 74                	push   $0x74
  jmp alltraps
801055fa:	e9 b2 f7 ff ff       	jmp    80104db1 <alltraps>

801055ff <vector117>:
.globl vector117
vector117:
  pushl $0
801055ff:	6a 00                	push   $0x0
  pushl $117
80105601:	6a 75                	push   $0x75
  jmp alltraps
80105603:	e9 a9 f7 ff ff       	jmp    80104db1 <alltraps>

80105608 <vector118>:
.globl vector118
vector118:
  pushl $0
80105608:	6a 00                	push   $0x0
  pushl $118
8010560a:	6a 76                	push   $0x76
  jmp alltraps
8010560c:	e9 a0 f7 ff ff       	jmp    80104db1 <alltraps>

80105611 <vector119>:
.globl vector119
vector119:
  pushl $0
80105611:	6a 00                	push   $0x0
  pushl $119
80105613:	6a 77                	push   $0x77
  jmp alltraps
80105615:	e9 97 f7 ff ff       	jmp    80104db1 <alltraps>

8010561a <vector120>:
.globl vector120
vector120:
  pushl $0
8010561a:	6a 00                	push   $0x0
  pushl $120
8010561c:	6a 78                	push   $0x78
  jmp alltraps
8010561e:	e9 8e f7 ff ff       	jmp    80104db1 <alltraps>

80105623 <vector121>:
.globl vector121
vector121:
  pushl $0
80105623:	6a 00                	push   $0x0
  pushl $121
80105625:	6a 79                	push   $0x79
  jmp alltraps
80105627:	e9 85 f7 ff ff       	jmp    80104db1 <alltraps>

8010562c <vector122>:
.globl vector122
vector122:
  pushl $0
8010562c:	6a 00                	push   $0x0
  pushl $122
8010562e:	6a 7a                	push   $0x7a
  jmp alltraps
80105630:	e9 7c f7 ff ff       	jmp    80104db1 <alltraps>

80105635 <vector123>:
.globl vector123
vector123:
  pushl $0
80105635:	6a 00                	push   $0x0
  pushl $123
80105637:	6a 7b                	push   $0x7b
  jmp alltraps
80105639:	e9 73 f7 ff ff       	jmp    80104db1 <alltraps>

8010563e <vector124>:
.globl vector124
vector124:
  pushl $0
8010563e:	6a 00                	push   $0x0
  pushl $124
80105640:	6a 7c                	push   $0x7c
  jmp alltraps
80105642:	e9 6a f7 ff ff       	jmp    80104db1 <alltraps>

80105647 <vector125>:
.globl vector125
vector125:
  pushl $0
80105647:	6a 00                	push   $0x0
  pushl $125
80105649:	6a 7d                	push   $0x7d
  jmp alltraps
8010564b:	e9 61 f7 ff ff       	jmp    80104db1 <alltraps>

80105650 <vector126>:
.globl vector126
vector126:
  pushl $0
80105650:	6a 00                	push   $0x0
  pushl $126
80105652:	6a 7e                	push   $0x7e
  jmp alltraps
80105654:	e9 58 f7 ff ff       	jmp    80104db1 <alltraps>

80105659 <vector127>:
.globl vector127
vector127:
  pushl $0
80105659:	6a 00                	push   $0x0
  pushl $127
8010565b:	6a 7f                	push   $0x7f
  jmp alltraps
8010565d:	e9 4f f7 ff ff       	jmp    80104db1 <alltraps>

80105662 <vector128>:
.globl vector128
vector128:
  pushl $0
80105662:	6a 00                	push   $0x0
  pushl $128
80105664:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105669:	e9 43 f7 ff ff       	jmp    80104db1 <alltraps>

8010566e <vector129>:
.globl vector129
vector129:
  pushl $0
8010566e:	6a 00                	push   $0x0
  pushl $129
80105670:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105675:	e9 37 f7 ff ff       	jmp    80104db1 <alltraps>

8010567a <vector130>:
.globl vector130
vector130:
  pushl $0
8010567a:	6a 00                	push   $0x0
  pushl $130
8010567c:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80105681:	e9 2b f7 ff ff       	jmp    80104db1 <alltraps>

80105686 <vector131>:
.globl vector131
vector131:
  pushl $0
80105686:	6a 00                	push   $0x0
  pushl $131
80105688:	68 83 00 00 00       	push   $0x83
  jmp alltraps
8010568d:	e9 1f f7 ff ff       	jmp    80104db1 <alltraps>

80105692 <vector132>:
.globl vector132
vector132:
  pushl $0
80105692:	6a 00                	push   $0x0
  pushl $132
80105694:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80105699:	e9 13 f7 ff ff       	jmp    80104db1 <alltraps>

8010569e <vector133>:
.globl vector133
vector133:
  pushl $0
8010569e:	6a 00                	push   $0x0
  pushl $133
801056a0:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801056a5:	e9 07 f7 ff ff       	jmp    80104db1 <alltraps>

801056aa <vector134>:
.globl vector134
vector134:
  pushl $0
801056aa:	6a 00                	push   $0x0
  pushl $134
801056ac:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801056b1:	e9 fb f6 ff ff       	jmp    80104db1 <alltraps>

801056b6 <vector135>:
.globl vector135
vector135:
  pushl $0
801056b6:	6a 00                	push   $0x0
  pushl $135
801056b8:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801056bd:	e9 ef f6 ff ff       	jmp    80104db1 <alltraps>

801056c2 <vector136>:
.globl vector136
vector136:
  pushl $0
801056c2:	6a 00                	push   $0x0
  pushl $136
801056c4:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801056c9:	e9 e3 f6 ff ff       	jmp    80104db1 <alltraps>

801056ce <vector137>:
.globl vector137
vector137:
  pushl $0
801056ce:	6a 00                	push   $0x0
  pushl $137
801056d0:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801056d5:	e9 d7 f6 ff ff       	jmp    80104db1 <alltraps>

801056da <vector138>:
.globl vector138
vector138:
  pushl $0
801056da:	6a 00                	push   $0x0
  pushl $138
801056dc:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801056e1:	e9 cb f6 ff ff       	jmp    80104db1 <alltraps>

801056e6 <vector139>:
.globl vector139
vector139:
  pushl $0
801056e6:	6a 00                	push   $0x0
  pushl $139
801056e8:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801056ed:	e9 bf f6 ff ff       	jmp    80104db1 <alltraps>

801056f2 <vector140>:
.globl vector140
vector140:
  pushl $0
801056f2:	6a 00                	push   $0x0
  pushl $140
801056f4:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801056f9:	e9 b3 f6 ff ff       	jmp    80104db1 <alltraps>

801056fe <vector141>:
.globl vector141
vector141:
  pushl $0
801056fe:	6a 00                	push   $0x0
  pushl $141
80105700:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105705:	e9 a7 f6 ff ff       	jmp    80104db1 <alltraps>

8010570a <vector142>:
.globl vector142
vector142:
  pushl $0
8010570a:	6a 00                	push   $0x0
  pushl $142
8010570c:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105711:	e9 9b f6 ff ff       	jmp    80104db1 <alltraps>

80105716 <vector143>:
.globl vector143
vector143:
  pushl $0
80105716:	6a 00                	push   $0x0
  pushl $143
80105718:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010571d:	e9 8f f6 ff ff       	jmp    80104db1 <alltraps>

80105722 <vector144>:
.globl vector144
vector144:
  pushl $0
80105722:	6a 00                	push   $0x0
  pushl $144
80105724:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105729:	e9 83 f6 ff ff       	jmp    80104db1 <alltraps>

8010572e <vector145>:
.globl vector145
vector145:
  pushl $0
8010572e:	6a 00                	push   $0x0
  pushl $145
80105730:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105735:	e9 77 f6 ff ff       	jmp    80104db1 <alltraps>

8010573a <vector146>:
.globl vector146
vector146:
  pushl $0
8010573a:	6a 00                	push   $0x0
  pushl $146
8010573c:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105741:	e9 6b f6 ff ff       	jmp    80104db1 <alltraps>

80105746 <vector147>:
.globl vector147
vector147:
  pushl $0
80105746:	6a 00                	push   $0x0
  pushl $147
80105748:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010574d:	e9 5f f6 ff ff       	jmp    80104db1 <alltraps>

80105752 <vector148>:
.globl vector148
vector148:
  pushl $0
80105752:	6a 00                	push   $0x0
  pushl $148
80105754:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105759:	e9 53 f6 ff ff       	jmp    80104db1 <alltraps>

8010575e <vector149>:
.globl vector149
vector149:
  pushl $0
8010575e:	6a 00                	push   $0x0
  pushl $149
80105760:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105765:	e9 47 f6 ff ff       	jmp    80104db1 <alltraps>

8010576a <vector150>:
.globl vector150
vector150:
  pushl $0
8010576a:	6a 00                	push   $0x0
  pushl $150
8010576c:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80105771:	e9 3b f6 ff ff       	jmp    80104db1 <alltraps>

80105776 <vector151>:
.globl vector151
vector151:
  pushl $0
80105776:	6a 00                	push   $0x0
  pushl $151
80105778:	68 97 00 00 00       	push   $0x97
  jmp alltraps
8010577d:	e9 2f f6 ff ff       	jmp    80104db1 <alltraps>

80105782 <vector152>:
.globl vector152
vector152:
  pushl $0
80105782:	6a 00                	push   $0x0
  pushl $152
80105784:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80105789:	e9 23 f6 ff ff       	jmp    80104db1 <alltraps>

8010578e <vector153>:
.globl vector153
vector153:
  pushl $0
8010578e:	6a 00                	push   $0x0
  pushl $153
80105790:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80105795:	e9 17 f6 ff ff       	jmp    80104db1 <alltraps>

8010579a <vector154>:
.globl vector154
vector154:
  pushl $0
8010579a:	6a 00                	push   $0x0
  pushl $154
8010579c:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801057a1:	e9 0b f6 ff ff       	jmp    80104db1 <alltraps>

801057a6 <vector155>:
.globl vector155
vector155:
  pushl $0
801057a6:	6a 00                	push   $0x0
  pushl $155
801057a8:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801057ad:	e9 ff f5 ff ff       	jmp    80104db1 <alltraps>

801057b2 <vector156>:
.globl vector156
vector156:
  pushl $0
801057b2:	6a 00                	push   $0x0
  pushl $156
801057b4:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801057b9:	e9 f3 f5 ff ff       	jmp    80104db1 <alltraps>

801057be <vector157>:
.globl vector157
vector157:
  pushl $0
801057be:	6a 00                	push   $0x0
  pushl $157
801057c0:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801057c5:	e9 e7 f5 ff ff       	jmp    80104db1 <alltraps>

801057ca <vector158>:
.globl vector158
vector158:
  pushl $0
801057ca:	6a 00                	push   $0x0
  pushl $158
801057cc:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801057d1:	e9 db f5 ff ff       	jmp    80104db1 <alltraps>

801057d6 <vector159>:
.globl vector159
vector159:
  pushl $0
801057d6:	6a 00                	push   $0x0
  pushl $159
801057d8:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801057dd:	e9 cf f5 ff ff       	jmp    80104db1 <alltraps>

801057e2 <vector160>:
.globl vector160
vector160:
  pushl $0
801057e2:	6a 00                	push   $0x0
  pushl $160
801057e4:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801057e9:	e9 c3 f5 ff ff       	jmp    80104db1 <alltraps>

801057ee <vector161>:
.globl vector161
vector161:
  pushl $0
801057ee:	6a 00                	push   $0x0
  pushl $161
801057f0:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801057f5:	e9 b7 f5 ff ff       	jmp    80104db1 <alltraps>

801057fa <vector162>:
.globl vector162
vector162:
  pushl $0
801057fa:	6a 00                	push   $0x0
  pushl $162
801057fc:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105801:	e9 ab f5 ff ff       	jmp    80104db1 <alltraps>

80105806 <vector163>:
.globl vector163
vector163:
  pushl $0
80105806:	6a 00                	push   $0x0
  pushl $163
80105808:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010580d:	e9 9f f5 ff ff       	jmp    80104db1 <alltraps>

80105812 <vector164>:
.globl vector164
vector164:
  pushl $0
80105812:	6a 00                	push   $0x0
  pushl $164
80105814:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105819:	e9 93 f5 ff ff       	jmp    80104db1 <alltraps>

8010581e <vector165>:
.globl vector165
vector165:
  pushl $0
8010581e:	6a 00                	push   $0x0
  pushl $165
80105820:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105825:	e9 87 f5 ff ff       	jmp    80104db1 <alltraps>

8010582a <vector166>:
.globl vector166
vector166:
  pushl $0
8010582a:	6a 00                	push   $0x0
  pushl $166
8010582c:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105831:	e9 7b f5 ff ff       	jmp    80104db1 <alltraps>

80105836 <vector167>:
.globl vector167
vector167:
  pushl $0
80105836:	6a 00                	push   $0x0
  pushl $167
80105838:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010583d:	e9 6f f5 ff ff       	jmp    80104db1 <alltraps>

80105842 <vector168>:
.globl vector168
vector168:
  pushl $0
80105842:	6a 00                	push   $0x0
  pushl $168
80105844:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105849:	e9 63 f5 ff ff       	jmp    80104db1 <alltraps>

8010584e <vector169>:
.globl vector169
vector169:
  pushl $0
8010584e:	6a 00                	push   $0x0
  pushl $169
80105850:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105855:	e9 57 f5 ff ff       	jmp    80104db1 <alltraps>

8010585a <vector170>:
.globl vector170
vector170:
  pushl $0
8010585a:	6a 00                	push   $0x0
  pushl $170
8010585c:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80105861:	e9 4b f5 ff ff       	jmp    80104db1 <alltraps>

80105866 <vector171>:
.globl vector171
vector171:
  pushl $0
80105866:	6a 00                	push   $0x0
  pushl $171
80105868:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
8010586d:	e9 3f f5 ff ff       	jmp    80104db1 <alltraps>

80105872 <vector172>:
.globl vector172
vector172:
  pushl $0
80105872:	6a 00                	push   $0x0
  pushl $172
80105874:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105879:	e9 33 f5 ff ff       	jmp    80104db1 <alltraps>

8010587e <vector173>:
.globl vector173
vector173:
  pushl $0
8010587e:	6a 00                	push   $0x0
  pushl $173
80105880:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80105885:	e9 27 f5 ff ff       	jmp    80104db1 <alltraps>

8010588a <vector174>:
.globl vector174
vector174:
  pushl $0
8010588a:	6a 00                	push   $0x0
  pushl $174
8010588c:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80105891:	e9 1b f5 ff ff       	jmp    80104db1 <alltraps>

80105896 <vector175>:
.globl vector175
vector175:
  pushl $0
80105896:	6a 00                	push   $0x0
  pushl $175
80105898:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
8010589d:	e9 0f f5 ff ff       	jmp    80104db1 <alltraps>

801058a2 <vector176>:
.globl vector176
vector176:
  pushl $0
801058a2:	6a 00                	push   $0x0
  pushl $176
801058a4:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801058a9:	e9 03 f5 ff ff       	jmp    80104db1 <alltraps>

801058ae <vector177>:
.globl vector177
vector177:
  pushl $0
801058ae:	6a 00                	push   $0x0
  pushl $177
801058b0:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801058b5:	e9 f7 f4 ff ff       	jmp    80104db1 <alltraps>

801058ba <vector178>:
.globl vector178
vector178:
  pushl $0
801058ba:	6a 00                	push   $0x0
  pushl $178
801058bc:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801058c1:	e9 eb f4 ff ff       	jmp    80104db1 <alltraps>

801058c6 <vector179>:
.globl vector179
vector179:
  pushl $0
801058c6:	6a 00                	push   $0x0
  pushl $179
801058c8:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801058cd:	e9 df f4 ff ff       	jmp    80104db1 <alltraps>

801058d2 <vector180>:
.globl vector180
vector180:
  pushl $0
801058d2:	6a 00                	push   $0x0
  pushl $180
801058d4:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801058d9:	e9 d3 f4 ff ff       	jmp    80104db1 <alltraps>

801058de <vector181>:
.globl vector181
vector181:
  pushl $0
801058de:	6a 00                	push   $0x0
  pushl $181
801058e0:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801058e5:	e9 c7 f4 ff ff       	jmp    80104db1 <alltraps>

801058ea <vector182>:
.globl vector182
vector182:
  pushl $0
801058ea:	6a 00                	push   $0x0
  pushl $182
801058ec:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801058f1:	e9 bb f4 ff ff       	jmp    80104db1 <alltraps>

801058f6 <vector183>:
.globl vector183
vector183:
  pushl $0
801058f6:	6a 00                	push   $0x0
  pushl $183
801058f8:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801058fd:	e9 af f4 ff ff       	jmp    80104db1 <alltraps>

80105902 <vector184>:
.globl vector184
vector184:
  pushl $0
80105902:	6a 00                	push   $0x0
  pushl $184
80105904:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105909:	e9 a3 f4 ff ff       	jmp    80104db1 <alltraps>

8010590e <vector185>:
.globl vector185
vector185:
  pushl $0
8010590e:	6a 00                	push   $0x0
  pushl $185
80105910:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105915:	e9 97 f4 ff ff       	jmp    80104db1 <alltraps>

8010591a <vector186>:
.globl vector186
vector186:
  pushl $0
8010591a:	6a 00                	push   $0x0
  pushl $186
8010591c:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105921:	e9 8b f4 ff ff       	jmp    80104db1 <alltraps>

80105926 <vector187>:
.globl vector187
vector187:
  pushl $0
80105926:	6a 00                	push   $0x0
  pushl $187
80105928:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
8010592d:	e9 7f f4 ff ff       	jmp    80104db1 <alltraps>

80105932 <vector188>:
.globl vector188
vector188:
  pushl $0
80105932:	6a 00                	push   $0x0
  pushl $188
80105934:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105939:	e9 73 f4 ff ff       	jmp    80104db1 <alltraps>

8010593e <vector189>:
.globl vector189
vector189:
  pushl $0
8010593e:	6a 00                	push   $0x0
  pushl $189
80105940:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105945:	e9 67 f4 ff ff       	jmp    80104db1 <alltraps>

8010594a <vector190>:
.globl vector190
vector190:
  pushl $0
8010594a:	6a 00                	push   $0x0
  pushl $190
8010594c:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105951:	e9 5b f4 ff ff       	jmp    80104db1 <alltraps>

80105956 <vector191>:
.globl vector191
vector191:
  pushl $0
80105956:	6a 00                	push   $0x0
  pushl $191
80105958:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
8010595d:	e9 4f f4 ff ff       	jmp    80104db1 <alltraps>

80105962 <vector192>:
.globl vector192
vector192:
  pushl $0
80105962:	6a 00                	push   $0x0
  pushl $192
80105964:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105969:	e9 43 f4 ff ff       	jmp    80104db1 <alltraps>

8010596e <vector193>:
.globl vector193
vector193:
  pushl $0
8010596e:	6a 00                	push   $0x0
  pushl $193
80105970:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105975:	e9 37 f4 ff ff       	jmp    80104db1 <alltraps>

8010597a <vector194>:
.globl vector194
vector194:
  pushl $0
8010597a:	6a 00                	push   $0x0
  pushl $194
8010597c:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105981:	e9 2b f4 ff ff       	jmp    80104db1 <alltraps>

80105986 <vector195>:
.globl vector195
vector195:
  pushl $0
80105986:	6a 00                	push   $0x0
  pushl $195
80105988:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
8010598d:	e9 1f f4 ff ff       	jmp    80104db1 <alltraps>

80105992 <vector196>:
.globl vector196
vector196:
  pushl $0
80105992:	6a 00                	push   $0x0
  pushl $196
80105994:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105999:	e9 13 f4 ff ff       	jmp    80104db1 <alltraps>

8010599e <vector197>:
.globl vector197
vector197:
  pushl $0
8010599e:	6a 00                	push   $0x0
  pushl $197
801059a0:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801059a5:	e9 07 f4 ff ff       	jmp    80104db1 <alltraps>

801059aa <vector198>:
.globl vector198
vector198:
  pushl $0
801059aa:	6a 00                	push   $0x0
  pushl $198
801059ac:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801059b1:	e9 fb f3 ff ff       	jmp    80104db1 <alltraps>

801059b6 <vector199>:
.globl vector199
vector199:
  pushl $0
801059b6:	6a 00                	push   $0x0
  pushl $199
801059b8:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801059bd:	e9 ef f3 ff ff       	jmp    80104db1 <alltraps>

801059c2 <vector200>:
.globl vector200
vector200:
  pushl $0
801059c2:	6a 00                	push   $0x0
  pushl $200
801059c4:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801059c9:	e9 e3 f3 ff ff       	jmp    80104db1 <alltraps>

801059ce <vector201>:
.globl vector201
vector201:
  pushl $0
801059ce:	6a 00                	push   $0x0
  pushl $201
801059d0:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801059d5:	e9 d7 f3 ff ff       	jmp    80104db1 <alltraps>

801059da <vector202>:
.globl vector202
vector202:
  pushl $0
801059da:	6a 00                	push   $0x0
  pushl $202
801059dc:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801059e1:	e9 cb f3 ff ff       	jmp    80104db1 <alltraps>

801059e6 <vector203>:
.globl vector203
vector203:
  pushl $0
801059e6:	6a 00                	push   $0x0
  pushl $203
801059e8:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801059ed:	e9 bf f3 ff ff       	jmp    80104db1 <alltraps>

801059f2 <vector204>:
.globl vector204
vector204:
  pushl $0
801059f2:	6a 00                	push   $0x0
  pushl $204
801059f4:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801059f9:	e9 b3 f3 ff ff       	jmp    80104db1 <alltraps>

801059fe <vector205>:
.globl vector205
vector205:
  pushl $0
801059fe:	6a 00                	push   $0x0
  pushl $205
80105a00:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105a05:	e9 a7 f3 ff ff       	jmp    80104db1 <alltraps>

80105a0a <vector206>:
.globl vector206
vector206:
  pushl $0
80105a0a:	6a 00                	push   $0x0
  pushl $206
80105a0c:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105a11:	e9 9b f3 ff ff       	jmp    80104db1 <alltraps>

80105a16 <vector207>:
.globl vector207
vector207:
  pushl $0
80105a16:	6a 00                	push   $0x0
  pushl $207
80105a18:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105a1d:	e9 8f f3 ff ff       	jmp    80104db1 <alltraps>

80105a22 <vector208>:
.globl vector208
vector208:
  pushl $0
80105a22:	6a 00                	push   $0x0
  pushl $208
80105a24:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105a29:	e9 83 f3 ff ff       	jmp    80104db1 <alltraps>

80105a2e <vector209>:
.globl vector209
vector209:
  pushl $0
80105a2e:	6a 00                	push   $0x0
  pushl $209
80105a30:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105a35:	e9 77 f3 ff ff       	jmp    80104db1 <alltraps>

80105a3a <vector210>:
.globl vector210
vector210:
  pushl $0
80105a3a:	6a 00                	push   $0x0
  pushl $210
80105a3c:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105a41:	e9 6b f3 ff ff       	jmp    80104db1 <alltraps>

80105a46 <vector211>:
.globl vector211
vector211:
  pushl $0
80105a46:	6a 00                	push   $0x0
  pushl $211
80105a48:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105a4d:	e9 5f f3 ff ff       	jmp    80104db1 <alltraps>

80105a52 <vector212>:
.globl vector212
vector212:
  pushl $0
80105a52:	6a 00                	push   $0x0
  pushl $212
80105a54:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105a59:	e9 53 f3 ff ff       	jmp    80104db1 <alltraps>

80105a5e <vector213>:
.globl vector213
vector213:
  pushl $0
80105a5e:	6a 00                	push   $0x0
  pushl $213
80105a60:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105a65:	e9 47 f3 ff ff       	jmp    80104db1 <alltraps>

80105a6a <vector214>:
.globl vector214
vector214:
  pushl $0
80105a6a:	6a 00                	push   $0x0
  pushl $214
80105a6c:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105a71:	e9 3b f3 ff ff       	jmp    80104db1 <alltraps>

80105a76 <vector215>:
.globl vector215
vector215:
  pushl $0
80105a76:	6a 00                	push   $0x0
  pushl $215
80105a78:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105a7d:	e9 2f f3 ff ff       	jmp    80104db1 <alltraps>

80105a82 <vector216>:
.globl vector216
vector216:
  pushl $0
80105a82:	6a 00                	push   $0x0
  pushl $216
80105a84:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105a89:	e9 23 f3 ff ff       	jmp    80104db1 <alltraps>

80105a8e <vector217>:
.globl vector217
vector217:
  pushl $0
80105a8e:	6a 00                	push   $0x0
  pushl $217
80105a90:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105a95:	e9 17 f3 ff ff       	jmp    80104db1 <alltraps>

80105a9a <vector218>:
.globl vector218
vector218:
  pushl $0
80105a9a:	6a 00                	push   $0x0
  pushl $218
80105a9c:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105aa1:	e9 0b f3 ff ff       	jmp    80104db1 <alltraps>

80105aa6 <vector219>:
.globl vector219
vector219:
  pushl $0
80105aa6:	6a 00                	push   $0x0
  pushl $219
80105aa8:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105aad:	e9 ff f2 ff ff       	jmp    80104db1 <alltraps>

80105ab2 <vector220>:
.globl vector220
vector220:
  pushl $0
80105ab2:	6a 00                	push   $0x0
  pushl $220
80105ab4:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105ab9:	e9 f3 f2 ff ff       	jmp    80104db1 <alltraps>

80105abe <vector221>:
.globl vector221
vector221:
  pushl $0
80105abe:	6a 00                	push   $0x0
  pushl $221
80105ac0:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105ac5:	e9 e7 f2 ff ff       	jmp    80104db1 <alltraps>

80105aca <vector222>:
.globl vector222
vector222:
  pushl $0
80105aca:	6a 00                	push   $0x0
  pushl $222
80105acc:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105ad1:	e9 db f2 ff ff       	jmp    80104db1 <alltraps>

80105ad6 <vector223>:
.globl vector223
vector223:
  pushl $0
80105ad6:	6a 00                	push   $0x0
  pushl $223
80105ad8:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105add:	e9 cf f2 ff ff       	jmp    80104db1 <alltraps>

80105ae2 <vector224>:
.globl vector224
vector224:
  pushl $0
80105ae2:	6a 00                	push   $0x0
  pushl $224
80105ae4:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105ae9:	e9 c3 f2 ff ff       	jmp    80104db1 <alltraps>

80105aee <vector225>:
.globl vector225
vector225:
  pushl $0
80105aee:	6a 00                	push   $0x0
  pushl $225
80105af0:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105af5:	e9 b7 f2 ff ff       	jmp    80104db1 <alltraps>

80105afa <vector226>:
.globl vector226
vector226:
  pushl $0
80105afa:	6a 00                	push   $0x0
  pushl $226
80105afc:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105b01:	e9 ab f2 ff ff       	jmp    80104db1 <alltraps>

80105b06 <vector227>:
.globl vector227
vector227:
  pushl $0
80105b06:	6a 00                	push   $0x0
  pushl $227
80105b08:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105b0d:	e9 9f f2 ff ff       	jmp    80104db1 <alltraps>

80105b12 <vector228>:
.globl vector228
vector228:
  pushl $0
80105b12:	6a 00                	push   $0x0
  pushl $228
80105b14:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105b19:	e9 93 f2 ff ff       	jmp    80104db1 <alltraps>

80105b1e <vector229>:
.globl vector229
vector229:
  pushl $0
80105b1e:	6a 00                	push   $0x0
  pushl $229
80105b20:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105b25:	e9 87 f2 ff ff       	jmp    80104db1 <alltraps>

80105b2a <vector230>:
.globl vector230
vector230:
  pushl $0
80105b2a:	6a 00                	push   $0x0
  pushl $230
80105b2c:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105b31:	e9 7b f2 ff ff       	jmp    80104db1 <alltraps>

80105b36 <vector231>:
.globl vector231
vector231:
  pushl $0
80105b36:	6a 00                	push   $0x0
  pushl $231
80105b38:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105b3d:	e9 6f f2 ff ff       	jmp    80104db1 <alltraps>

80105b42 <vector232>:
.globl vector232
vector232:
  pushl $0
80105b42:	6a 00                	push   $0x0
  pushl $232
80105b44:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105b49:	e9 63 f2 ff ff       	jmp    80104db1 <alltraps>

80105b4e <vector233>:
.globl vector233
vector233:
  pushl $0
80105b4e:	6a 00                	push   $0x0
  pushl $233
80105b50:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105b55:	e9 57 f2 ff ff       	jmp    80104db1 <alltraps>

80105b5a <vector234>:
.globl vector234
vector234:
  pushl $0
80105b5a:	6a 00                	push   $0x0
  pushl $234
80105b5c:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105b61:	e9 4b f2 ff ff       	jmp    80104db1 <alltraps>

80105b66 <vector235>:
.globl vector235
vector235:
  pushl $0
80105b66:	6a 00                	push   $0x0
  pushl $235
80105b68:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105b6d:	e9 3f f2 ff ff       	jmp    80104db1 <alltraps>

80105b72 <vector236>:
.globl vector236
vector236:
  pushl $0
80105b72:	6a 00                	push   $0x0
  pushl $236
80105b74:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105b79:	e9 33 f2 ff ff       	jmp    80104db1 <alltraps>

80105b7e <vector237>:
.globl vector237
vector237:
  pushl $0
80105b7e:	6a 00                	push   $0x0
  pushl $237
80105b80:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105b85:	e9 27 f2 ff ff       	jmp    80104db1 <alltraps>

80105b8a <vector238>:
.globl vector238
vector238:
  pushl $0
80105b8a:	6a 00                	push   $0x0
  pushl $238
80105b8c:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105b91:	e9 1b f2 ff ff       	jmp    80104db1 <alltraps>

80105b96 <vector239>:
.globl vector239
vector239:
  pushl $0
80105b96:	6a 00                	push   $0x0
  pushl $239
80105b98:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105b9d:	e9 0f f2 ff ff       	jmp    80104db1 <alltraps>

80105ba2 <vector240>:
.globl vector240
vector240:
  pushl $0
80105ba2:	6a 00                	push   $0x0
  pushl $240
80105ba4:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105ba9:	e9 03 f2 ff ff       	jmp    80104db1 <alltraps>

80105bae <vector241>:
.globl vector241
vector241:
  pushl $0
80105bae:	6a 00                	push   $0x0
  pushl $241
80105bb0:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105bb5:	e9 f7 f1 ff ff       	jmp    80104db1 <alltraps>

80105bba <vector242>:
.globl vector242
vector242:
  pushl $0
80105bba:	6a 00                	push   $0x0
  pushl $242
80105bbc:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105bc1:	e9 eb f1 ff ff       	jmp    80104db1 <alltraps>

80105bc6 <vector243>:
.globl vector243
vector243:
  pushl $0
80105bc6:	6a 00                	push   $0x0
  pushl $243
80105bc8:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105bcd:	e9 df f1 ff ff       	jmp    80104db1 <alltraps>

80105bd2 <vector244>:
.globl vector244
vector244:
  pushl $0
80105bd2:	6a 00                	push   $0x0
  pushl $244
80105bd4:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105bd9:	e9 d3 f1 ff ff       	jmp    80104db1 <alltraps>

80105bde <vector245>:
.globl vector245
vector245:
  pushl $0
80105bde:	6a 00                	push   $0x0
  pushl $245
80105be0:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105be5:	e9 c7 f1 ff ff       	jmp    80104db1 <alltraps>

80105bea <vector246>:
.globl vector246
vector246:
  pushl $0
80105bea:	6a 00                	push   $0x0
  pushl $246
80105bec:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105bf1:	e9 bb f1 ff ff       	jmp    80104db1 <alltraps>

80105bf6 <vector247>:
.globl vector247
vector247:
  pushl $0
80105bf6:	6a 00                	push   $0x0
  pushl $247
80105bf8:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105bfd:	e9 af f1 ff ff       	jmp    80104db1 <alltraps>

80105c02 <vector248>:
.globl vector248
vector248:
  pushl $0
80105c02:	6a 00                	push   $0x0
  pushl $248
80105c04:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105c09:	e9 a3 f1 ff ff       	jmp    80104db1 <alltraps>

80105c0e <vector249>:
.globl vector249
vector249:
  pushl $0
80105c0e:	6a 00                	push   $0x0
  pushl $249
80105c10:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105c15:	e9 97 f1 ff ff       	jmp    80104db1 <alltraps>

80105c1a <vector250>:
.globl vector250
vector250:
  pushl $0
80105c1a:	6a 00                	push   $0x0
  pushl $250
80105c1c:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105c21:	e9 8b f1 ff ff       	jmp    80104db1 <alltraps>

80105c26 <vector251>:
.globl vector251
vector251:
  pushl $0
80105c26:	6a 00                	push   $0x0
  pushl $251
80105c28:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105c2d:	e9 7f f1 ff ff       	jmp    80104db1 <alltraps>

80105c32 <vector252>:
.globl vector252
vector252:
  pushl $0
80105c32:	6a 00                	push   $0x0
  pushl $252
80105c34:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105c39:	e9 73 f1 ff ff       	jmp    80104db1 <alltraps>

80105c3e <vector253>:
.globl vector253
vector253:
  pushl $0
80105c3e:	6a 00                	push   $0x0
  pushl $253
80105c40:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105c45:	e9 67 f1 ff ff       	jmp    80104db1 <alltraps>

80105c4a <vector254>:
.globl vector254
vector254:
  pushl $0
80105c4a:	6a 00                	push   $0x0
  pushl $254
80105c4c:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105c51:	e9 5b f1 ff ff       	jmp    80104db1 <alltraps>

80105c56 <vector255>:
.globl vector255
vector255:
  pushl $0
80105c56:	6a 00                	push   $0x0
  pushl $255
80105c58:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105c5d:	e9 4f f1 ff ff       	jmp    80104db1 <alltraps>
80105c62:	66 90                	xchg   %ax,%ax

80105c64 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105c64:	55                   	push   %ebp
80105c65:	89 e5                	mov    %esp,%ebp
80105c67:	57                   	push   %edi
80105c68:	56                   	push   %esi
80105c69:	53                   	push   %ebx
80105c6a:	83 ec 1c             	sub    $0x1c,%esp
80105c6d:	89 d7                	mov    %edx,%edi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105c6f:	89 d3                	mov    %edx,%ebx
80105c71:	c1 eb 16             	shr    $0x16,%ebx
80105c74:	8d 34 98             	lea    (%eax,%ebx,4),%esi
  if(*pde & PTE_P){
80105c77:	8b 1e                	mov    (%esi),%ebx
80105c79:	f6 c3 01             	test   $0x1,%bl
80105c7c:	74 22                	je     80105ca0 <walkpgdir+0x3c>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105c7e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105c84:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105c8a:	89 fa                	mov    %edi,%edx
80105c8c:	c1 ea 0a             	shr    $0xa,%edx
80105c8f:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80105c95:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80105c98:	83 c4 1c             	add    $0x1c,%esp
80105c9b:	5b                   	pop    %ebx
80105c9c:	5e                   	pop    %esi
80105c9d:	5f                   	pop    %edi
80105c9e:	5d                   	pop    %ebp
80105c9f:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105ca0:	85 c9                	test   %ecx,%ecx
80105ca2:	74 30                	je     80105cd4 <walkpgdir+0x70>
80105ca4:	e8 43 c5 ff ff       	call   801021ec <kalloc>
80105ca9:	89 c3                	mov    %eax,%ebx
80105cab:	85 c0                	test   %eax,%eax
80105cad:	74 25                	je     80105cd4 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80105caf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80105cb6:	00 
80105cb7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105cbe:	00 
80105cbf:	89 04 24             	mov    %eax,(%esp)
80105cc2:	e8 bd e0 ff ff       	call   80103d84 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105cc7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80105ccd:	83 c8 07             	or     $0x7,%eax
80105cd0:	89 06                	mov    %eax,(%esi)
80105cd2:	eb b6                	jmp    80105c8a <walkpgdir+0x26>
      return 0;
80105cd4:	31 c0                	xor    %eax,%eax
}
80105cd6:	83 c4 1c             	add    $0x1c,%esp
80105cd9:	5b                   	pop    %ebx
80105cda:	5e                   	pop    %esi
80105cdb:	5f                   	pop    %edi
80105cdc:	5d                   	pop    %ebp
80105cdd:	c3                   	ret    
80105cde:	66 90                	xchg   %ax,%ax

80105ce0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80105ce0:	55                   	push   %ebp
80105ce1:	89 e5                	mov    %esp,%ebp
80105ce3:	57                   	push   %edi
80105ce4:	56                   	push   %esi
80105ce5:	53                   	push   %ebx
80105ce6:	83 ec 2c             	sub    $0x2c,%esp
80105ce9:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105cec:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80105cef:	89 d3                	mov    %edx,%ebx
80105cf1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105cf7:	8d 4c 0a ff          	lea    -0x1(%edx,%ecx,1),%ecx
80105cfb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80105cfe:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
80105d05:	29 df                	sub    %ebx,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80105d07:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
80105d0b:	eb 18                	jmp    80105d25 <mappages+0x45>
80105d0d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*pte & PTE_P)
80105d10:	f6 00 01             	testb  $0x1,(%eax)
80105d13:	75 3d                	jne    80105d52 <mappages+0x72>
    *pte = pa | perm | PTE_P;
80105d15:	0b 75 0c             	or     0xc(%ebp),%esi
80105d18:	89 30                	mov    %esi,(%eax)
    if(a == last)
80105d1a:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80105d1d:	74 29                	je     80105d48 <mappages+0x68>
      break;
    a += PGSIZE;
80105d1f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
80105d25:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105d28:	b9 01 00 00 00       	mov    $0x1,%ecx
80105d2d:	89 da                	mov    %ebx,%edx
80105d2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105d32:	e8 2d ff ff ff       	call   80105c64 <walkpgdir>
80105d37:	85 c0                	test   %eax,%eax
80105d39:	75 d5                	jne    80105d10 <mappages+0x30>
      return -1;
80105d3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    pa += PGSIZE;
  }
  return 0;
}
80105d40:	83 c4 2c             	add    $0x2c,%esp
80105d43:	5b                   	pop    %ebx
80105d44:	5e                   	pop    %esi
80105d45:	5f                   	pop    %edi
80105d46:	5d                   	pop    %ebp
80105d47:	c3                   	ret    
  return 0;
80105d48:	31 c0                	xor    %eax,%eax
}
80105d4a:	83 c4 2c             	add    $0x2c,%esp
80105d4d:	5b                   	pop    %ebx
80105d4e:	5e                   	pop    %esi
80105d4f:	5f                   	pop    %edi
80105d50:	5d                   	pop    %ebp
80105d51:	c3                   	ret    
      panic("remap");
80105d52:	c7 04 24 dc 74 10 80 	movl   $0x801074dc,(%esp)
80105d59:	e8 b2 a5 ff ff       	call   80100310 <panic>
80105d5e:	66 90                	xchg   %ax,%ax

80105d60 <seginit>:
{
80105d60:	55                   	push   %ebp
80105d61:	89 e5                	mov    %esp,%ebp
80105d63:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80105d66:	e8 f1 d4 ff ff       	call   8010325c <cpuid>
80105d6b:	8d 14 80             	lea    (%eax,%eax,4),%edx
80105d6e:	8d 04 50             	lea    (%eax,%edx,2),%eax
80105d71:	c1 e0 04             	shl    $0x4,%eax
80105d74:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80105d79:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80105d7f:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80105d85:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80105d89:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
80105d8d:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
80105d91:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80105d95:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80105d9c:	ff ff 
80105d9e:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80105da5:	00 00 
80105da7:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80105dae:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
80105db5:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
80105dbc:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80105dc3:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80105dca:	ff ff 
80105dcc:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80105dd3:	00 00 
80105dd5:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80105ddc:	c6 80 8d 00 00 00 fa 	movb   $0xfa,0x8d(%eax)
80105de3:	c6 80 8e 00 00 00 cf 	movb   $0xcf,0x8e(%eax)
80105dea:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80105df1:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80105df8:	ff ff 
80105dfa:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80105e01:	00 00 
80105e03:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80105e0a:	c6 80 95 00 00 00 f2 	movb   $0xf2,0x95(%eax)
80105e11:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
80105e18:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80105e1f:	83 c0 70             	add    $0x70,%eax
  pd[0] = size-1;
80105e22:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80105e28:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80105e2c:	c1 e8 10             	shr    $0x10,%eax
80105e2f:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80105e33:	8d 45 f2             	lea    -0xe(%ebp),%eax
80105e36:	0f 01 10             	lgdtl  (%eax)
}
80105e39:	c9                   	leave  
80105e3a:	c3                   	ret    
80105e3b:	90                   	nop

80105e3c <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80105e3c:	55                   	push   %ebp
80105e3d:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80105e3f:	a1 a4 57 11 80       	mov    0x801157a4,%eax
80105e44:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105e49:	0f 22 d8             	mov    %eax,%cr3
}
80105e4c:	5d                   	pop    %ebp
80105e4d:	c3                   	ret    
80105e4e:	66 90                	xchg   %ax,%ax

80105e50 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80105e50:	55                   	push   %ebp
80105e51:	89 e5                	mov    %esp,%ebp
80105e53:	57                   	push   %edi
80105e54:	56                   	push   %esi
80105e55:	53                   	push   %ebx
80105e56:	83 ec 2c             	sub    $0x2c,%esp
80105e59:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80105e5c:	85 f6                	test   %esi,%esi
80105e5e:	0f 84 c4 00 00 00    	je     80105f28 <switchuvm+0xd8>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80105e64:	8b 56 08             	mov    0x8(%esi),%edx
80105e67:	85 d2                	test   %edx,%edx
80105e69:	0f 84 d1 00 00 00    	je     80105f40 <switchuvm+0xf0>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80105e6f:	8b 46 04             	mov    0x4(%esi),%eax
80105e72:	85 c0                	test   %eax,%eax
80105e74:	0f 84 ba 00 00 00    	je     80105f34 <switchuvm+0xe4>
    panic("switchuvm: no pgdir");

  pushcli();
80105e7a:	e8 c9 dd ff ff       	call   80103c48 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80105e7f:	e8 64 d3 ff ff       	call   801031e8 <mycpu>
80105e84:	89 c3                	mov    %eax,%ebx
80105e86:	e8 5d d3 ff ff       	call   801031e8 <mycpu>
80105e8b:	89 c7                	mov    %eax,%edi
80105e8d:	e8 56 d3 ff ff       	call   801031e8 <mycpu>
80105e92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105e95:	e8 4e d3 ff ff       	call   801031e8 <mycpu>
80105e9a:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80105ea1:	67 00 
80105ea3:	83 c7 08             	add    $0x8,%edi
80105ea6:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80105ead:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105eb0:	83 c1 08             	add    $0x8,%ecx
80105eb3:	c1 e9 10             	shr    $0x10,%ecx
80105eb6:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80105ebc:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80105ec3:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80105eca:	83 c0 08             	add    $0x8,%eax
80105ecd:	c1 e8 18             	shr    $0x18,%eax
80105ed0:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80105ed6:	e8 0d d3 ff ff       	call   801031e8 <mycpu>
80105edb:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80105ee2:	e8 01 d3 ff ff       	call   801031e8 <mycpu>
80105ee7:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80105eed:	e8 f6 d2 ff ff       	call   801031e8 <mycpu>
80105ef2:	8b 4e 08             	mov    0x8(%esi),%ecx
80105ef5:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80105efb:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80105efe:	e8 e5 d2 ff ff       	call   801031e8 <mycpu>
80105f03:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80105f09:	b8 28 00 00 00       	mov    $0x28,%eax
80105f0e:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80105f11:	8b 46 04             	mov    0x4(%esi),%eax
80105f14:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105f19:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80105f1c:	83 c4 2c             	add    $0x2c,%esp
80105f1f:	5b                   	pop    %ebx
80105f20:	5e                   	pop    %esi
80105f21:	5f                   	pop    %edi
80105f22:	5d                   	pop    %ebp
  popcli();
80105f23:	e9 bc dd ff ff       	jmp    80103ce4 <popcli>
    panic("switchuvm: no process");
80105f28:	c7 04 24 e2 74 10 80 	movl   $0x801074e2,(%esp)
80105f2f:	e8 dc a3 ff ff       	call   80100310 <panic>
    panic("switchuvm: no pgdir");
80105f34:	c7 04 24 0d 75 10 80 	movl   $0x8010750d,(%esp)
80105f3b:	e8 d0 a3 ff ff       	call   80100310 <panic>
    panic("switchuvm: no kstack");
80105f40:	c7 04 24 f8 74 10 80 	movl   $0x801074f8,(%esp)
80105f47:	e8 c4 a3 ff ff       	call   80100310 <panic>

80105f4c <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80105f4c:	55                   	push   %ebp
80105f4d:	89 e5                	mov    %esp,%ebp
80105f4f:	57                   	push   %edi
80105f50:	56                   	push   %esi
80105f51:	53                   	push   %ebx
80105f52:	83 ec 2c             	sub    $0x2c,%esp
80105f55:	8b 45 08             	mov    0x8(%ebp),%eax
80105f58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105f5b:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105f5e:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
80105f61:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80105f67:	77 54                	ja     80105fbd <inituvm+0x71>
    panic("inituvm: more than a page");
  mem = kalloc();
80105f69:	e8 7e c2 ff ff       	call   801021ec <kalloc>
80105f6e:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80105f70:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80105f77:	00 
80105f78:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105f7f:	00 
80105f80:	89 04 24             	mov    %eax,(%esp)
80105f83:	e8 fc dd ff ff       	call   80103d84 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80105f88:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80105f8f:	00 
80105f90:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80105f96:	89 04 24             	mov    %eax,(%esp)
80105f99:	b9 00 10 00 00       	mov    $0x1000,%ecx
80105f9e:	31 d2                	xor    %edx,%edx
80105fa0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fa3:	e8 38 fd ff ff       	call   80105ce0 <mappages>
  memmove(mem, init, sz);
80105fa8:	89 75 10             	mov    %esi,0x10(%ebp)
80105fab:	89 7d 0c             	mov    %edi,0xc(%ebp)
80105fae:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80105fb1:	83 c4 2c             	add    $0x2c,%esp
80105fb4:	5b                   	pop    %ebx
80105fb5:	5e                   	pop    %esi
80105fb6:	5f                   	pop    %edi
80105fb7:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80105fb8:	e9 5b de ff ff       	jmp    80103e18 <memmove>
    panic("inituvm: more than a page");
80105fbd:	c7 04 24 21 75 10 80 	movl   $0x80107521,(%esp)
80105fc4:	e8 47 a3 ff ff       	call   80100310 <panic>
80105fc9:	8d 76 00             	lea    0x0(%esi),%esi

80105fcc <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80105fcc:	55                   	push   %ebp
80105fcd:	89 e5                	mov    %esp,%ebp
80105fcf:	57                   	push   %edi
80105fd0:	56                   	push   %esi
80105fd1:	53                   	push   %ebx
80105fd2:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80105fd5:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80105fdc:	0f 85 97 00 00 00    	jne    80106079 <loaduvm+0xad>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80105fe2:	8b 4d 18             	mov    0x18(%ebp),%ecx
80105fe5:	85 c9                	test   %ecx,%ecx
80105fe7:	74 6b                	je     80106054 <loaduvm+0x88>
80105fe9:	8b 75 18             	mov    0x18(%ebp),%esi
80105fec:	31 db                	xor    %ebx,%ebx
80105fee:	eb 3b                	jmp    8010602b <loaduvm+0x5f>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80105ff0:	bf 00 10 00 00       	mov    $0x1000,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80105ff5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
80105ff9:	8b 4d 14             	mov    0x14(%ebp),%ecx
80105ffc:	01 d9                	add    %ebx,%ecx
    if(readi(ip, P2V(pa), offset+i, n) != n)
80105ffe:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106002:	05 00 00 00 80       	add    $0x80000000,%eax
80106007:	89 44 24 04          	mov    %eax,0x4(%esp)
8010600b:	8b 45 10             	mov    0x10(%ebp),%eax
8010600e:	89 04 24             	mov    %eax,(%esp)
80106011:	e8 d6 b7 ff ff       	call   801017ec <readi>
80106016:	39 f8                	cmp    %edi,%eax
80106018:	75 46                	jne    80106060 <loaduvm+0x94>
  for(i = 0; i < sz; i += PGSIZE){
8010601a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106020:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106026:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106029:	76 29                	jbe    80106054 <loaduvm+0x88>
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
8010602b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010602e:	01 da                	add    %ebx,%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106030:	31 c9                	xor    %ecx,%ecx
80106032:	8b 45 08             	mov    0x8(%ebp),%eax
80106035:	e8 2a fc ff ff       	call   80105c64 <walkpgdir>
8010603a:	85 c0                	test   %eax,%eax
8010603c:	74 2f                	je     8010606d <loaduvm+0xa1>
    pa = PTE_ADDR(*pte);
8010603e:	8b 00                	mov    (%eax),%eax
80106040:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106045:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010604b:	77 a3                	ja     80105ff0 <loaduvm+0x24>
8010604d:	89 f7                	mov    %esi,%edi
8010604f:	eb a4                	jmp    80105ff5 <loaduvm+0x29>
80106051:	8d 76 00             	lea    0x0(%esi),%esi
      return -1;
  }
  return 0;
80106054:	31 c0                	xor    %eax,%eax
}
80106056:	83 c4 1c             	add    $0x1c,%esp
80106059:	5b                   	pop    %ebx
8010605a:	5e                   	pop    %esi
8010605b:	5f                   	pop    %edi
8010605c:	5d                   	pop    %ebp
8010605d:	c3                   	ret    
8010605e:	66 90                	xchg   %ax,%ax
      return -1;
80106060:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106065:	83 c4 1c             	add    $0x1c,%esp
80106068:	5b                   	pop    %ebx
80106069:	5e                   	pop    %esi
8010606a:	5f                   	pop    %edi
8010606b:	5d                   	pop    %ebp
8010606c:	c3                   	ret    
      panic("loaduvm: address should exist");
8010606d:	c7 04 24 3b 75 10 80 	movl   $0x8010753b,(%esp)
80106074:	e8 97 a2 ff ff       	call   80100310 <panic>
    panic("loaduvm: addr must be page aligned");
80106079:	c7 04 24 dc 75 10 80 	movl   $0x801075dc,(%esp)
80106080:	e8 8b a2 ff ff       	call   80100310 <panic>
80106085:	8d 76 00             	lea    0x0(%esi),%esi

80106088 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106088:	55                   	push   %ebp
80106089:	89 e5                	mov    %esp,%ebp
8010608b:	57                   	push   %edi
8010608c:	56                   	push   %esi
8010608d:	53                   	push   %ebx
8010608e:	83 ec 2c             	sub    $0x2c,%esp
80106091:	8b 7d 08             	mov    0x8(%ebp),%edi
80106094:	8b 75 0c             	mov    0xc(%ebp),%esi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106097:	39 75 10             	cmp    %esi,0x10(%ebp)
8010609a:	73 7c                	jae    80106118 <deallocuvm+0x90>
    return oldsz;

  a = PGROUNDUP(newsz);
8010609c:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010609f:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
801060a5:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801060ab:	39 de                	cmp    %ebx,%esi
801060ad:	77 38                	ja     801060e7 <deallocuvm+0x5f>
801060af:	eb 5b                	jmp    8010610c <deallocuvm+0x84>
801060b1:	8d 76 00             	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801060b4:	8b 10                	mov    (%eax),%edx
801060b6:	f6 c2 01             	test   $0x1,%dl
801060b9:	74 22                	je     801060dd <deallocuvm+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801060bb:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801060c1:	74 5f                	je     80106122 <deallocuvm+0x9a>
        panic("kfree");
      char *v = P2V(pa);
801060c3:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801060c9:	89 14 24             	mov    %edx,(%esp)
801060cc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801060cf:	e8 dc bf ff ff       	call   801020b0 <kfree>
      *pte = 0;
801060d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801060dd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801060e3:	39 de                	cmp    %ebx,%esi
801060e5:	76 25                	jbe    8010610c <deallocuvm+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
801060e7:	31 c9                	xor    %ecx,%ecx
801060e9:	89 da                	mov    %ebx,%edx
801060eb:	89 f8                	mov    %edi,%eax
801060ed:	e8 72 fb ff ff       	call   80105c64 <walkpgdir>
    if(!pte)
801060f2:	85 c0                	test   %eax,%eax
801060f4:	75 be                	jne    801060b4 <deallocuvm+0x2c>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801060f6:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801060fc:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106102:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106108:	39 de                	cmp    %ebx,%esi
8010610a:	77 db                	ja     801060e7 <deallocuvm+0x5f>
    }
  }
  return newsz;
8010610c:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010610f:	83 c4 2c             	add    $0x2c,%esp
80106112:	5b                   	pop    %ebx
80106113:	5e                   	pop    %esi
80106114:	5f                   	pop    %edi
80106115:	5d                   	pop    %ebp
80106116:	c3                   	ret    
80106117:	90                   	nop
    return oldsz;
80106118:	89 f0                	mov    %esi,%eax
}
8010611a:	83 c4 2c             	add    $0x2c,%esp
8010611d:	5b                   	pop    %ebx
8010611e:	5e                   	pop    %esi
8010611f:	5f                   	pop    %edi
80106120:	5d                   	pop    %ebp
80106121:	c3                   	ret    
        panic("kfree");
80106122:	c7 04 24 86 6e 10 80 	movl   $0x80106e86,(%esp)
80106129:	e8 e2 a1 ff ff       	call   80100310 <panic>
8010612e:	66 90                	xchg   %ax,%ax

80106130 <allocuvm>:
{
80106130:	55                   	push   %ebp
80106131:	89 e5                	mov    %esp,%ebp
80106133:	57                   	push   %edi
80106134:	56                   	push   %esi
80106135:	53                   	push   %ebx
80106136:	83 ec 2c             	sub    $0x2c,%esp
  if(newsz >= KERNBASE)
80106139:	8b 7d 10             	mov    0x10(%ebp),%edi
8010613c:	85 ff                	test   %edi,%edi
8010613e:	0f 88 c4 00 00 00    	js     80106208 <allocuvm+0xd8>
  if(newsz < oldsz)
80106144:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106147:	0f 82 ab 00 00 00    	jb     801061f8 <allocuvm+0xc8>
  a = PGROUNDUP(oldsz);
8010614d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80106150:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
80106156:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010615c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010615f:	0f 86 96 00 00 00    	jbe    801061fb <allocuvm+0xcb>
80106165:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106168:	8b 7d 08             	mov    0x8(%ebp),%edi
8010616b:	eb 4d                	jmp    801061ba <allocuvm+0x8a>
8010616d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80106170:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106177:	00 
80106178:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010617f:	00 
80106180:	89 04 24             	mov    %eax,(%esp)
80106183:	e8 fc db ff ff       	call   80103d84 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106188:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
8010618f:	00 
80106190:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106196:	89 04 24             	mov    %eax,(%esp)
80106199:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010619e:	89 da                	mov    %ebx,%edx
801061a0:	89 f8                	mov    %edi,%eax
801061a2:	e8 39 fb ff ff       	call   80105ce0 <mappages>
801061a7:	85 c0                	test   %eax,%eax
801061a9:	78 69                	js     80106214 <allocuvm+0xe4>
  for(; a < newsz; a += PGSIZE){
801061ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801061b1:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801061b4:	0f 86 96 00 00 00    	jbe    80106250 <allocuvm+0x120>
    mem = kalloc();
801061ba:	e8 2d c0 ff ff       	call   801021ec <kalloc>
801061bf:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801061c1:	85 c0                	test   %eax,%eax
801061c3:	75 ab                	jne    80106170 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801061c5:	c7 04 24 59 75 10 80 	movl   $0x80107559,(%esp)
801061cc:	e8 e3 a3 ff ff       	call   801005b4 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801061d1:	8b 45 0c             	mov    0xc(%ebp),%eax
801061d4:	89 44 24 08          	mov    %eax,0x8(%esp)
801061d8:	8b 45 10             	mov    0x10(%ebp),%eax
801061db:	89 44 24 04          	mov    %eax,0x4(%esp)
801061df:	8b 45 08             	mov    0x8(%ebp),%eax
801061e2:	89 04 24             	mov    %eax,(%esp)
801061e5:	e8 9e fe ff ff       	call   80106088 <deallocuvm>
      return 0;
801061ea:	31 ff                	xor    %edi,%edi
}
801061ec:	89 f8                	mov    %edi,%eax
801061ee:	83 c4 2c             	add    $0x2c,%esp
801061f1:	5b                   	pop    %ebx
801061f2:	5e                   	pop    %esi
801061f3:	5f                   	pop    %edi
801061f4:	5d                   	pop    %ebp
801061f5:	c3                   	ret    
801061f6:	66 90                	xchg   %ax,%ax
    return oldsz;
801061f8:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801061fb:	89 f8                	mov    %edi,%eax
801061fd:	83 c4 2c             	add    $0x2c,%esp
80106200:	5b                   	pop    %ebx
80106201:	5e                   	pop    %esi
80106202:	5f                   	pop    %edi
80106203:	5d                   	pop    %ebp
80106204:	c3                   	ret    
80106205:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
80106208:	31 ff                	xor    %edi,%edi
}
8010620a:	89 f8                	mov    %edi,%eax
8010620c:	83 c4 2c             	add    $0x2c,%esp
8010620f:	5b                   	pop    %ebx
80106210:	5e                   	pop    %esi
80106211:	5f                   	pop    %edi
80106212:	5d                   	pop    %ebp
80106213:	c3                   	ret    
      cprintf("allocuvm out of memory (2)\n");
80106214:	c7 04 24 71 75 10 80 	movl   $0x80107571,(%esp)
8010621b:	e8 94 a3 ff ff       	call   801005b4 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106220:	8b 45 0c             	mov    0xc(%ebp),%eax
80106223:	89 44 24 08          	mov    %eax,0x8(%esp)
80106227:	8b 45 10             	mov    0x10(%ebp),%eax
8010622a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010622e:	8b 45 08             	mov    0x8(%ebp),%eax
80106231:	89 04 24             	mov    %eax,(%esp)
80106234:	e8 4f fe ff ff       	call   80106088 <deallocuvm>
      kfree(mem);
80106239:	89 34 24             	mov    %esi,(%esp)
8010623c:	e8 6f be ff ff       	call   801020b0 <kfree>
      return 0;
80106241:	31 ff                	xor    %edi,%edi
}
80106243:	89 f8                	mov    %edi,%eax
80106245:	83 c4 2c             	add    $0x2c,%esp
80106248:	5b                   	pop    %ebx
80106249:	5e                   	pop    %esi
8010624a:	5f                   	pop    %edi
8010624b:	5d                   	pop    %ebp
8010624c:	c3                   	ret    
8010624d:	8d 76 00             	lea    0x0(%esi),%esi
80106250:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80106253:	89 f8                	mov    %edi,%eax
80106255:	83 c4 2c             	add    $0x2c,%esp
80106258:	5b                   	pop    %ebx
80106259:	5e                   	pop    %esi
8010625a:	5f                   	pop    %edi
8010625b:	5d                   	pop    %ebp
8010625c:	c3                   	ret    
8010625d:	8d 76 00             	lea    0x0(%esi),%esi

80106260 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106260:	55                   	push   %ebp
80106261:	89 e5                	mov    %esp,%ebp
80106263:	56                   	push   %esi
80106264:	53                   	push   %ebx
80106265:	83 ec 10             	sub    $0x10,%esp
80106268:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010626b:	85 f6                	test   %esi,%esi
8010626d:	74 56                	je     801062c5 <freevm+0x65>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
8010626f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106276:	00 
80106277:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
8010627e:	80 
8010627f:	89 34 24             	mov    %esi,(%esp)
80106282:	e8 01 fe ff ff       	call   80106088 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80106287:	31 db                	xor    %ebx,%ebx
80106289:	eb 0a                	jmp    80106295 <freevm+0x35>
8010628b:	90                   	nop
8010628c:	43                   	inc    %ebx
8010628d:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106293:	74 22                	je     801062b7 <freevm+0x57>
    if(pgdir[i] & PTE_P){
80106295:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
80106298:	a8 01                	test   $0x1,%al
8010629a:	74 f0                	je     8010628c <freevm+0x2c>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010629c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801062a1:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801062a6:	89 04 24             	mov    %eax,(%esp)
801062a9:	e8 02 be ff ff       	call   801020b0 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
801062ae:	43                   	inc    %ebx
801062af:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801062b5:	75 de                	jne    80106295 <freevm+0x35>
    }
  }
  kfree((char*)pgdir);
801062b7:	89 75 08             	mov    %esi,0x8(%ebp)
}
801062ba:	83 c4 10             	add    $0x10,%esp
801062bd:	5b                   	pop    %ebx
801062be:	5e                   	pop    %esi
801062bf:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801062c0:	e9 eb bd ff ff       	jmp    801020b0 <kfree>
    panic("freevm: no pgdir");
801062c5:	c7 04 24 8d 75 10 80 	movl   $0x8010758d,(%esp)
801062cc:	e8 3f a0 ff ff       	call   80100310 <panic>
801062d1:	8d 76 00             	lea    0x0(%esi),%esi

801062d4 <setupkvm>:
{
801062d4:	55                   	push   %ebp
801062d5:	89 e5                	mov    %esp,%ebp
801062d7:	56                   	push   %esi
801062d8:	53                   	push   %ebx
801062d9:	83 ec 10             	sub    $0x10,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
801062dc:	e8 0b bf ff ff       	call   801021ec <kalloc>
801062e1:	89 c6                	mov    %eax,%esi
801062e3:	85 c0                	test   %eax,%eax
801062e5:	74 47                	je     8010632e <setupkvm+0x5a>
  memset(pgdir, 0, PGSIZE);
801062e7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801062ee:	00 
801062ef:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801062f6:	00 
801062f7:	89 04 24             	mov    %eax,(%esp)
801062fa:	e8 85 da ff ff       	call   80103d84 <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801062ff:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106304:	8b 43 04             	mov    0x4(%ebx),%eax
80106307:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010630a:	29 c1                	sub    %eax,%ecx
8010630c:	8b 53 0c             	mov    0xc(%ebx),%edx
8010630f:	89 54 24 04          	mov    %edx,0x4(%esp)
80106313:	89 04 24             	mov    %eax,(%esp)
80106316:	8b 13                	mov    (%ebx),%edx
80106318:	89 f0                	mov    %esi,%eax
8010631a:	e8 c1 f9 ff ff       	call   80105ce0 <mappages>
8010631f:	85 c0                	test   %eax,%eax
80106321:	78 15                	js     80106338 <setupkvm+0x64>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106323:	83 c3 10             	add    $0x10,%ebx
80106326:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
8010632c:	72 d6                	jb     80106304 <setupkvm+0x30>
}
8010632e:	89 f0                	mov    %esi,%eax
80106330:	83 c4 10             	add    $0x10,%esp
80106333:	5b                   	pop    %ebx
80106334:	5e                   	pop    %esi
80106335:	5d                   	pop    %ebp
80106336:	c3                   	ret    
80106337:	90                   	nop
      freevm(pgdir);
80106338:	89 34 24             	mov    %esi,(%esp)
8010633b:	e8 20 ff ff ff       	call   80106260 <freevm>
      return 0;
80106340:	31 f6                	xor    %esi,%esi
}
80106342:	89 f0                	mov    %esi,%eax
80106344:	83 c4 10             	add    $0x10,%esp
80106347:	5b                   	pop    %ebx
80106348:	5e                   	pop    %esi
80106349:	5d                   	pop    %ebp
8010634a:	c3                   	ret    
8010634b:	90                   	nop

8010634c <kvmalloc>:
{
8010634c:	55                   	push   %ebp
8010634d:	89 e5                	mov    %esp,%ebp
8010634f:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106352:	e8 7d ff ff ff       	call   801062d4 <setupkvm>
80106357:	a3 a4 57 11 80       	mov    %eax,0x801157a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
8010635c:	05 00 00 00 80       	add    $0x80000000,%eax
80106361:	0f 22 d8             	mov    %eax,%cr3
}
80106364:	c9                   	leave  
80106365:	c3                   	ret    
80106366:	66 90                	xchg   %ax,%ax

80106368 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106368:	55                   	push   %ebp
80106369:	89 e5                	mov    %esp,%ebp
8010636b:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010636e:	31 c9                	xor    %ecx,%ecx
80106370:	8b 55 0c             	mov    0xc(%ebp),%edx
80106373:	8b 45 08             	mov    0x8(%ebp),%eax
80106376:	e8 e9 f8 ff ff       	call   80105c64 <walkpgdir>
  if(pte == 0)
8010637b:	85 c0                	test   %eax,%eax
8010637d:	74 05                	je     80106384 <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010637f:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106382:	c9                   	leave  
80106383:	c3                   	ret    
    panic("clearpteu");
80106384:	c7 04 24 9e 75 10 80 	movl   $0x8010759e,(%esp)
8010638b:	e8 80 9f ff ff       	call   80100310 <panic>

80106390 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106390:	55                   	push   %ebp
80106391:	89 e5                	mov    %esp,%ebp
80106393:	57                   	push   %edi
80106394:	56                   	push   %esi
80106395:	53                   	push   %ebx
80106396:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106399:	e8 36 ff ff ff       	call   801062d4 <setupkvm>
8010639e:	89 45 e0             	mov    %eax,-0x20(%ebp)
801063a1:	85 c0                	test   %eax,%eax
801063a3:	0f 84 9f 00 00 00    	je     80106448 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801063a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801063ac:	85 db                	test   %ebx,%ebx
801063ae:	0f 84 94 00 00 00    	je     80106448 <copyuvm+0xb8>
801063b4:	31 db                	xor    %ebx,%ebx
801063b6:	eb 48                	jmp    80106400 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801063b8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801063bf:	00 
801063c0:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801063c6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801063ca:	89 04 24             	mov    %eax,(%esp)
801063cd:	e8 46 da ff ff       	call   80103e18 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801063d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063d5:	89 44 24 04          	mov    %eax,0x4(%esp)
801063d9:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
801063df:	89 14 24             	mov    %edx,(%esp)
801063e2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801063e7:	89 da                	mov    %ebx,%edx
801063e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801063ec:	e8 ef f8 ff ff       	call   80105ce0 <mappages>
801063f1:	85 c0                	test   %eax,%eax
801063f3:	78 41                	js     80106436 <copyuvm+0xa6>
  for(i = 0; i < sz; i += PGSIZE){
801063f5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801063fb:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
801063fe:	76 48                	jbe    80106448 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106400:	31 c9                	xor    %ecx,%ecx
80106402:	89 da                	mov    %ebx,%edx
80106404:	8b 45 08             	mov    0x8(%ebp),%eax
80106407:	e8 58 f8 ff ff       	call   80105c64 <walkpgdir>
8010640c:	85 c0                	test   %eax,%eax
8010640e:	74 43                	je     80106453 <copyuvm+0xc3>
    if(!(*pte & PTE_P))
80106410:	8b 30                	mov    (%eax),%esi
80106412:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106418:	74 45                	je     8010645f <copyuvm+0xcf>
    pa = PTE_ADDR(*pte);
8010641a:	89 f7                	mov    %esi,%edi
8010641c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
80106422:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106428:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
8010642b:	e8 bc bd ff ff       	call   801021ec <kalloc>
80106430:	89 c6                	mov    %eax,%esi
80106432:	85 c0                	test   %eax,%eax
80106434:	75 82                	jne    801063b8 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106436:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106439:	89 04 24             	mov    %eax,(%esp)
8010643c:	e8 1f fe ff ff       	call   80106260 <freevm>
  return 0;
80106441:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80106448:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010644b:	83 c4 2c             	add    $0x2c,%esp
8010644e:	5b                   	pop    %ebx
8010644f:	5e                   	pop    %esi
80106450:	5f                   	pop    %edi
80106451:	5d                   	pop    %ebp
80106452:	c3                   	ret    
      panic("copyuvm: pte should exist");
80106453:	c7 04 24 a8 75 10 80 	movl   $0x801075a8,(%esp)
8010645a:	e8 b1 9e ff ff       	call   80100310 <panic>
      panic("copyuvm: page not present");
8010645f:	c7 04 24 c2 75 10 80 	movl   $0x801075c2,(%esp)
80106466:	e8 a5 9e ff ff       	call   80100310 <panic>
8010646b:	90                   	nop

8010646c <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010646c:	55                   	push   %ebp
8010646d:	89 e5                	mov    %esp,%ebp
8010646f:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106472:	31 c9                	xor    %ecx,%ecx
80106474:	8b 55 0c             	mov    0xc(%ebp),%edx
80106477:	8b 45 08             	mov    0x8(%ebp),%eax
8010647a:	e8 e5 f7 ff ff       	call   80105c64 <walkpgdir>
  if((*pte & PTE_P) == 0)
8010647f:	8b 00                	mov    (%eax),%eax
80106481:	a8 01                	test   $0x1,%al
80106483:	74 13                	je     80106498 <uva2ka+0x2c>
    return 0;
  if((*pte & PTE_U) == 0)
80106485:	a8 04                	test   $0x4,%al
80106487:	74 0f                	je     80106498 <uva2ka+0x2c>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106489:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010648e:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106493:	c9                   	leave  
80106494:	c3                   	ret    
80106495:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
80106498:	31 c0                	xor    %eax,%eax
}
8010649a:	c9                   	leave  
8010649b:	c3                   	ret    

8010649c <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010649c:	55                   	push   %ebp
8010649d:	89 e5                	mov    %esp,%ebp
8010649f:	57                   	push   %edi
801064a0:	56                   	push   %esi
801064a1:	53                   	push   %ebx
801064a2:	83 ec 2c             	sub    $0x2c,%esp
801064a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801064a8:	8b 7d 10             	mov    0x10(%ebp),%edi
801064ab:	8b 45 14             	mov    0x14(%ebp),%eax
801064ae:	85 c0                	test   %eax,%eax
801064b0:	74 6e                	je     80106520 <copyout+0x84>
801064b2:	89 f0                	mov    %esi,%eax
801064b4:	89 fe                	mov    %edi,%esi
801064b6:	89 c7                	mov    %eax,%edi
801064b8:	eb 3d                	jmp    801064f7 <copyout+0x5b>
801064ba:	66 90                	xchg   %ax,%ax
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801064bc:	89 da                	mov    %ebx,%edx
801064be:	29 fa                	sub    %edi,%edx
801064c0:	81 c2 00 10 00 00    	add    $0x1000,%edx
801064c6:	3b 55 14             	cmp    0x14(%ebp),%edx
801064c9:	76 03                	jbe    801064ce <copyout+0x32>
801064cb:	8b 55 14             	mov    0x14(%ebp),%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801064ce:	89 54 24 08          	mov    %edx,0x8(%esp)
801064d2:	89 74 24 04          	mov    %esi,0x4(%esp)
801064d6:	89 f9                	mov    %edi,%ecx
801064d8:	29 d9                	sub    %ebx,%ecx
801064da:	01 c8                	add    %ecx,%eax
801064dc:	89 04 24             	mov    %eax,(%esp)
801064df:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801064e2:	e8 31 d9 ff ff       	call   80103e18 <memmove>
    len -= n;
    buf += n;
801064e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801064ea:	01 d6                	add    %edx,%esi
    va = va0 + PGSIZE;
801064ec:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
  while(len > 0){
801064f2:	29 55 14             	sub    %edx,0x14(%ebp)
801064f5:	74 29                	je     80106520 <copyout+0x84>
    va0 = (uint)PGROUNDDOWN(va);
801064f7:	89 fb                	mov    %edi,%ebx
801064f9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    pa0 = uva2ka(pgdir, (char*)va0);
801064ff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106503:	8b 45 08             	mov    0x8(%ebp),%eax
80106506:	89 04 24             	mov    %eax,(%esp)
80106509:	e8 5e ff ff ff       	call   8010646c <uva2ka>
    if(pa0 == 0)
8010650e:	85 c0                	test   %eax,%eax
80106510:	75 aa                	jne    801064bc <copyout+0x20>
      return -1;
80106512:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106517:	83 c4 2c             	add    $0x2c,%esp
8010651a:	5b                   	pop    %ebx
8010651b:	5e                   	pop    %esi
8010651c:	5f                   	pop    %edi
8010651d:	5d                   	pop    %ebp
8010651e:	c3                   	ret    
8010651f:	90                   	nop
  return 0;
80106520:	31 c0                	xor    %eax,%eax
}
80106522:	83 c4 2c             	add    $0x2c,%esp
80106525:	5b                   	pop    %ebx
80106526:	5e                   	pop    %esi
80106527:	5f                   	pop    %edi
80106528:	5d                   	pop    %ebp
80106529:	c3                   	ret    
8010652a:	66 90                	xchg   %ax,%ax

8010652c <printk_str>:
#include "types.h"
#include "defs.h"

int
printk_str(char *str){
8010652c:	55                   	push   %ebp
8010652d:	89 e5                	mov    %esp,%ebp
8010652f:	83 ec 18             	sub    $0x18,%esp
    cprintf("%s\n", str);
80106532:	8b 45 08             	mov    0x8(%ebp),%eax
80106535:	89 44 24 04          	mov    %eax,0x4(%esp)
80106539:	c7 04 24 00 76 10 80 	movl   $0x80107600,(%esp)
80106540:	e8 6f a0 ff ff       	call   801005b4 <cprintf>
    return 0xABCDABCD;
}
80106545:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
8010654a:	c9                   	leave  
8010654b:	c3                   	ret    

8010654c <sys_myfunction>:

//Wrapper for my_syscall
int
sys_myfunction(void){
8010654c:	55                   	push   %ebp
8010654d:	89 e5                	mov    %esp,%ebp
8010654f:	83 ec 28             	sub    $0x28,%esp
    char *str;
    //Decode argument using argstr
    if(argstr(0, &str) < 0)
80106552:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106555:	89 44 24 04          	mov    %eax,0x4(%esp)
80106559:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106560:	e8 0b db ff ff       	call   80104070 <argstr>
80106565:	85 c0                	test   %eax,%eax
80106567:	78 1b                	js     80106584 <sys_myfunction+0x38>
    cprintf("%s\n", str);
80106569:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010656c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106570:	c7 04 24 00 76 10 80 	movl   $0x80107600,(%esp)
80106577:	e8 38 a0 ff ff       	call   801005b4 <cprintf>
        return -1;
    return printk_str(str);
8010657c:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
}
80106581:	c9                   	leave  
80106582:	c3                   	ret    
80106583:	90                   	nop
        return -1;
80106584:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106589:	c9                   	leave  
8010658a:	c3                   	ret    
8010658b:	90                   	nop

8010658c <push_MLFQ>:
}ptable;


int
push_MLFQ(int prior, struct proc* p)
{
8010658c:	55                   	push   %ebp
8010658d:	89 e5                	mov    %esp,%ebp
8010658f:	53                   	push   %ebx
80106590:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106593:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if(prior < 0 || prior > 2)
80106596:	83 f9 02             	cmp    $0x2,%ecx
80106599:	77 59                	ja     801065f4 <push_MLFQ+0x68>
push_MLFQ(int prior, struct proc* p)
8010659b:	89 c8                	mov    %ecx,%eax
8010659d:	c1 e0 08             	shl    $0x8,%eax
801065a0:	8d 14 c8             	lea    (%eax,%ecx,8),%edx
801065a3:	31 c0                	xor    %eax,%eax
801065a5:	eb 07                	jmp    801065ae <push_MLFQ+0x22>
801065a7:	90                   	nop
		return -1;
	int i;
	for(i = 0; i < NPROC; i++){
801065a8:	40                   	inc    %eax
801065a9:	83 f8 40             	cmp    $0x40,%eax
801065ac:	74 46                	je     801065f4 <push_MLFQ+0x68>
		if(MLFQ_table[prior].wait[i] == 0){
801065ae:	83 bc 82 c8 5c 11 80 	cmpl   $0x0,-0x7feea338(%edx,%eax,4)
801065b5:	00 
801065b6:	75 f0                	jne    801065a8 <push_MLFQ+0x1c>
			MLFQ_table[prior].wait[i] = p;
801065b8:	89 ca                	mov    %ecx,%edx
801065ba:	c1 e2 06             	shl    $0x6,%edx
801065bd:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801065c0:	01 d0                	add    %edx,%eax
801065c2:	89 1c 85 c8 5c 11 80 	mov    %ebx,-0x7feea338(,%eax,4)
			p->prior = prior;
801065c9:	89 4b 7c             	mov    %ecx,0x7c(%ebx)
			p->pticks = 0;
801065cc:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801065d3:	00 00 00 
			p->myst = s_cand;
801065d6:	c7 83 84 00 00 00 c0 	movl   $0x801157c0,0x84(%ebx)
801065dd:	57 11 80 
			MLFQ_table[prior].total++;
801065e0:	89 c8                	mov    %ecx,%eax
801065e2:	c1 e0 08             	shl    $0x8,%eax
801065e5:	ff 84 c8 c0 5c 11 80 	incl   -0x7feea340(%eax,%ecx,8)
			return 0;
801065ec:	31 c0                	xor    %eax,%eax
		}
	}
	return -1;
}
801065ee:	5b                   	pop    %ebx
801065ef:	5d                   	pop    %ebp
801065f0:	c3                   	ret    
801065f1:	8d 76 00             	lea    0x0(%esi),%esi
		return -1;
801065f4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065f9:	5b                   	pop    %ebx
801065fa:	5d                   	pop    %ebp
801065fb:	c3                   	ret    

801065fc <pop_MLFQ>:

int
pop_MLFQ(struct proc* p)
{
801065fc:	55                   	push   %ebp
801065fd:	89 e5                	mov    %esp,%ebp
801065ff:	53                   	push   %ebx
80106600:	8b 55 08             	mov    0x8(%ebp),%edx
	int prior = p->prior;
80106603:	8b 5a 7c             	mov    0x7c(%edx),%ebx
pop_MLFQ(struct proc* p)
80106606:	89 d8                	mov    %ebx,%eax
80106608:	c1 e0 08             	shl    $0x8,%eax
8010660b:	8d 0c d8             	lea    (%eax,%ebx,8),%ecx
	int i;
	for(i = 0; i < NPROC; i++){
8010660e:	31 c0                	xor    %eax,%eax
80106610:	eb 08                	jmp    8010661a <pop_MLFQ+0x1e>
80106612:	66 90                	xchg   %ax,%ax
80106614:	40                   	inc    %eax
80106615:	83 f8 40             	cmp    $0x40,%eax
80106618:	74 3a                	je     80106654 <pop_MLFQ+0x58>
		if(MLFQ_table[prior].wait[i] == p){
8010661a:	39 94 81 c8 5c 11 80 	cmp    %edx,-0x7feea338(%ecx,%eax,4)
80106621:	75 f1                	jne    80106614 <pop_MLFQ+0x18>
			MLFQ_table[prior].wait[i] = 0;
80106623:	89 d9                	mov    %ebx,%ecx
80106625:	c1 e1 06             	shl    $0x6,%ecx
80106628:	8d 0c 59             	lea    (%ecx,%ebx,2),%ecx
8010662b:	01 c8                	add    %ecx,%eax
8010662d:	c7 04 85 c8 5c 11 80 	movl   $0x0,-0x7feea338(,%eax,4)
80106634:	00 00 00 00 
			p->pticks = 0;
80106638:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
8010663f:	00 00 00 
			MLFQ_table[prior].total--;
80106642:	89 d8                	mov    %ebx,%eax
80106644:	c1 e0 08             	shl    $0x8,%eax
80106647:	ff 8c d8 c0 5c 11 80 	decl   -0x7feea340(%eax,%ebx,8)
			return 0;
8010664e:	31 c0                	xor    %eax,%eax
		}
	}
	return -1;
}
80106650:	5b                   	pop    %ebx
80106651:	5d                   	pop    %ebp
80106652:	c3                   	ret    
80106653:	90                   	nop
	return -1;
80106654:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106659:	5b                   	pop    %ebx
8010665a:	5d                   	pop    %ebp
8010665b:	c3                   	ret    

8010665c <move_MLFQ_prior>:

int
move_MLFQ_prior(int prior, struct proc* p)
{
8010665c:	55                   	push   %ebp
8010665d:	89 e5                	mov    %esp,%ebp
8010665f:	56                   	push   %esi
80106660:	53                   	push   %ebx
80106661:	8b 5d 08             	mov    0x8(%ebp),%ebx
80106664:	8b 55 0c             	mov    0xc(%ebp),%edx
	int prior = p->prior;
80106667:	8b 72 7c             	mov    0x7c(%edx),%esi
move_MLFQ_prior(int prior, struct proc* p)
8010666a:	89 f0                	mov    %esi,%eax
8010666c:	c1 e0 08             	shl    $0x8,%eax
8010666f:	8d 0c f0             	lea    (%eax,%esi,8),%ecx
	for(i = 0; i < NPROC; i++){
80106672:	31 c0                	xor    %eax,%eax
80106674:	eb 0c                	jmp    80106682 <move_MLFQ_prior+0x26>
80106676:	66 90                	xchg   %ax,%ax
80106678:	40                   	inc    %eax
80106679:	83 f8 40             	cmp    $0x40,%eax
8010667c:	0f 84 92 00 00 00    	je     80106714 <move_MLFQ_prior+0xb8>
		if(MLFQ_table[prior].wait[i] == p){
80106682:	3b 94 81 c8 5c 11 80 	cmp    -0x7feea338(%ecx,%eax,4),%edx
80106689:	75 ed                	jne    80106678 <move_MLFQ_prior+0x1c>
			MLFQ_table[prior].wait[i] = 0;
8010668b:	89 f1                	mov    %esi,%ecx
8010668d:	c1 e1 06             	shl    $0x6,%ecx
80106690:	8d 0c 71             	lea    (%ecx,%esi,2),%ecx
80106693:	01 c8                	add    %ecx,%eax
80106695:	c7 04 85 c8 5c 11 80 	movl   $0x0,-0x7feea338(,%eax,4)
8010669c:	00 00 00 00 
			p->pticks = 0;
801066a0:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
801066a7:	00 00 00 
			MLFQ_table[prior].total--;
801066aa:	89 f0                	mov    %esi,%eax
801066ac:	c1 e0 08             	shl    $0x8,%eax
801066af:	ff 8c f0 c0 5c 11 80 	decl   -0x7feea340(%eax,%esi,8)
	if(prior < 0 || prior > 2)
801066b6:	83 fb 02             	cmp    $0x2,%ebx
801066b9:	77 59                	ja     80106714 <move_MLFQ_prior+0xb8>
move_MLFQ_prior(int prior, struct proc* p)
801066bb:	89 d8                	mov    %ebx,%eax
801066bd:	c1 e0 08             	shl    $0x8,%eax
801066c0:	8d 0c d8             	lea    (%eax,%ebx,8),%ecx
801066c3:	31 c0                	xor    %eax,%eax
801066c5:	eb 07                	jmp    801066ce <move_MLFQ_prior+0x72>
801066c7:	90                   	nop
	for(i = 0; i < NPROC; i++){
801066c8:	40                   	inc    %eax
801066c9:	83 f8 40             	cmp    $0x40,%eax
801066cc:	74 46                	je     80106714 <move_MLFQ_prior+0xb8>
		if(MLFQ_table[prior].wait[i] == 0){
801066ce:	8b b4 81 c8 5c 11 80 	mov    -0x7feea338(%ecx,%eax,4),%esi
801066d5:	85 f6                	test   %esi,%esi
801066d7:	75 ef                	jne    801066c8 <move_MLFQ_prior+0x6c>
			MLFQ_table[prior].wait[i] = p;
801066d9:	89 d9                	mov    %ebx,%ecx
801066db:	c1 e1 06             	shl    $0x6,%ecx
801066de:	8d 0c 59             	lea    (%ecx,%ebx,2),%ecx
801066e1:	01 c8                	add    %ecx,%eax
801066e3:	89 14 85 c8 5c 11 80 	mov    %edx,-0x7feea338(,%eax,4)
			p->prior = prior;
801066ea:	89 5a 7c             	mov    %ebx,0x7c(%edx)
			p->pticks = 0;
801066ed:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
801066f4:	00 00 00 
			p->myst = s_cand;
801066f7:	c7 82 84 00 00 00 c0 	movl   $0x801157c0,0x84(%edx)
801066fe:	57 11 80 
			MLFQ_table[prior].total++;
80106701:	89 d8                	mov    %ebx,%eax
80106703:	c1 e0 08             	shl    $0x8,%eax
80106706:	ff 84 d8 c0 5c 11 80 	incl   -0x7feea340(%eax,%ebx,8)
			return 0;
8010670d:	31 c0                	xor    %eax,%eax
	int ret = pop_MLFQ(p);
	if(ret == -1)
		return ret;
	return push_MLFQ(prior, p);
}
8010670f:	5b                   	pop    %ebx
80106710:	5e                   	pop    %esi
80106711:	5d                   	pop    %ebp
80106712:	c3                   	ret    
80106713:	90                   	nop
		return -1;
80106714:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106719:	5b                   	pop    %ebx
8010671a:	5e                   	pop    %esi
8010671b:	5d                   	pop    %ebp
8010671c:	c3                   	ret    
8010671d:	8d 76 00             	lea    0x0(%esi),%esi

80106720 <pick_MLFQ>:

struct proc*
pick_MLFQ(void)
{
80106720:	55                   	push   %ebp
80106721:	89 e5                	mov    %esp,%ebp
80106723:	57                   	push   %edi
80106724:	56                   	push   %esi
80106725:	53                   	push   %ebx
80106726:	83 ec 08             	sub    $0x8,%esp
80106729:	c7 45 ec c0 5c 11 80 	movl   $0x80115cc0,-0x14(%ebp)

	int i, j;

	for(i = 0; i < 3; i++){
80106730:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		if(MLFQ_table[i].total == 0){
80106737:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010673a:	8b 38                	mov    (%eax),%edi
8010673c:	85 ff                	test   %edi,%edi
8010673e:	74 40                	je     80106780 <pick_MLFQ+0x60>
			continue;
		}
		j = MLFQ_table[i].recent;
80106740:	8b 70 04             	mov    0x4(%eax),%esi
80106743:	89 f1                	mov    %esi,%ecx
		do{
			j = (j + 1) % NPROC;
			if(MLFQ_table[i].wait[j] != 0 && 
80106745:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106748:	c1 e0 06             	shl    $0x6,%eax
8010674b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010674e:	8d 3c 50             	lea    (%eax,%edx,2),%edi
80106751:	eb 1b                	jmp    8010676e <pick_MLFQ+0x4e>
80106753:	90                   	nop
			j = (j + 1) % NPROC;
80106754:	89 c1                	mov    %eax,%ecx
			if(MLFQ_table[i].wait[j] != 0 && 
80106756:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
80106759:	8b 14 9d c8 5c 11 80 	mov    -0x7feea338(,%ebx,4),%edx
80106760:	85 d2                	test   %edx,%edx
80106762:	74 06                	je     8010676a <pick_MLFQ+0x4a>
80106764:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80106768:	74 32                	je     8010679c <pick_MLFQ+0x7c>
				MLFQ_table[i].wait[j]->state == RUNNABLE){
				MLFQ_table[i].recent = j;
				return MLFQ_table[i].wait[j];
			}
		}while(j != MLFQ_table[i].recent);
8010676a:	39 c6                	cmp    %eax,%esi
8010676c:	74 12                	je     80106780 <pick_MLFQ+0x60>
			j = (j + 1) % NPROC;
8010676e:	8d 41 01             	lea    0x1(%ecx),%eax
80106771:	25 3f 00 00 80       	and    $0x8000003f,%eax
80106776:	79 dc                	jns    80106754 <pick_MLFQ+0x34>
80106778:	48                   	dec    %eax
80106779:	83 c8 c0             	or     $0xffffffc0,%eax
8010677c:	40                   	inc    %eax
8010677d:	eb d5                	jmp    80106754 <pick_MLFQ+0x34>
8010677f:	90                   	nop
	for(i = 0; i < 3; i++){
80106780:	ff 45 f0             	incl   -0x10(%ebp)
80106783:	81 45 ec 08 01 00 00 	addl   $0x108,-0x14(%ebp)
8010678a:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
8010678e:	75 a7                	jne    80106737 <pick_MLFQ+0x17>
	}
	
	return 0;
80106790:	31 c0                	xor    %eax,%eax
}
80106792:	83 c4 08             	add    $0x8,%esp
80106795:	5b                   	pop    %ebx
80106796:	5e                   	pop    %esi
80106797:	5f                   	pop    %edi
80106798:	5d                   	pop    %ebp
80106799:	c3                   	ret    
8010679a:	66 90                	xchg   %ax,%ax
				MLFQ_table[i].recent = j;
8010679c:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010679f:	c1 e2 08             	shl    $0x8,%edx
801067a2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801067a5:	89 84 ca c4 5c 11 80 	mov    %eax,-0x7feea33c(%edx,%ecx,8)
				return MLFQ_table[i].wait[j];
801067ac:	8b 04 9d c8 5c 11 80 	mov    -0x7feea338(,%ebx,4),%eax
}
801067b3:	83 c4 08             	add    $0x8,%esp
801067b6:	5b                   	pop    %ebx
801067b7:	5e                   	pop    %esi
801067b8:	5f                   	pop    %edi
801067b9:	5d                   	pop    %ebp
801067ba:	c3                   	ret    
801067bb:	90                   	nop

801067bc <prior_boost>:

void 
prior_boost(void)
{
801067bc:	55                   	push   %ebp
801067bd:	89 e5                	mov    %esp,%ebp
801067bf:	53                   	push   %ebx
801067c0:	83 ec 08             	sub    $0x8,%esp
	global_ticks = 0;
801067c3:	c7 05 a8 a5 10 80 00 	movl   $0x0,0x8010a5a8
801067ca:	00 00 00 

	
  	struct proc* p;
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801067cd:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801067d2:	eb 0e                	jmp    801067e2 <prior_boost+0x26>
801067d4:	81 c3 88 00 00 00    	add    $0x88,%ebx
801067da:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
801067e0:	74 24                	je     80106806 <prior_boost+0x4a>
		if(p->prior == 0 || p->prior == 1|| p->prior == 2) { 
801067e2:	83 7b 7c 02          	cmpl   $0x2,0x7c(%ebx)
801067e6:	77 ec                	ja     801067d4 <prior_boost+0x18>
			move_MLFQ_prior(0, p);
801067e8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801067ec:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801067f3:	e8 64 fe ff ff       	call   8010665c <move_MLFQ_prior>
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801067f8:	81 c3 88 00 00 00    	add    $0x88,%ebx
801067fe:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80106804:	75 dc                	jne    801067e2 <prior_boost+0x26>
		}
	}
	
	//cprintf("[do boosting!]\n");
}
80106806:	83 c4 08             	add    $0x8,%esp
80106809:	5b                   	pop    %ebx
8010680a:	5d                   	pop    %ebp
8010680b:	c3                   	ret    

8010680c <pick_pass>:

struct proc*
pick_pass(void)
{
8010680c:	55                   	push   %ebp
8010680d:	89 e5                	mov    %esp,%ebp
8010680f:	53                   	push   %ebx
	///제일 짧은 패스를 고른다.
	///MLFQ가 뽑혔다면, MLFQ에 의해서 다시 뽑아준다.
	struct stride* pick = s_cand;
	struct stride* s;
	int i = 0;
	for(s = s_cand; s < &s_cand[NPROC]; s++){
80106810:	b8 c0 57 11 80       	mov    $0x801157c0,%eax
	struct stride* pick = s_cand;
80106815:	89 c3                	mov    %eax,%ebx
80106817:	eb 0d                	jmp    80106826 <pick_pass+0x1a>
80106819:	8d 76 00             	lea    0x0(%esi),%esi
	for(s = s_cand; s < &s_cand[NPROC]; s++){
8010681c:	83 c0 14             	add    $0x14,%eax
8010681f:	3d c0 5c 11 80       	cmp    $0x80115cc0,%eax
80106824:	73 26                	jae    8010684c <pick_pass+0x40>
		//cprintf("%d -> ", i++);
		if(s->valid == 0){
80106826:	8b 48 0c             	mov    0xc(%eax),%ecx
80106829:	85 c9                	test   %ecx,%ecx
8010682b:	74 ef                	je     8010681c <pick_pass+0x10>
			//cprintf(" c1 ");
			continue;
		}
		if(s->proc->state != RUNNABLE){
8010682d:	8b 50 10             	mov    0x10(%eax),%edx
80106830:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80106834:	75 e6                	jne    8010681c <pick_pass+0x10>
			//cprintf(" c2 ");
			continue;
		}
		//cprintf("stride : %d pass : %d\t",s->stride, s->pass);
		i++;
		if(s->pass < pick->pass)
80106836:	8b 53 04             	mov    0x4(%ebx),%edx
80106839:	39 50 04             	cmp    %edx,0x4(%eax)
8010683c:	7d de                	jge    8010681c <pick_pass+0x10>
8010683e:	89 c3                	mov    %eax,%ebx
	for(s = s_cand; s < &s_cand[NPROC]; s++){
80106840:	83 c0 14             	add    $0x14,%eax
80106843:	3d c0 5c 11 80       	cmp    $0x80115cc0,%eax
80106848:	72 dc                	jb     80106826 <pick_pass+0x1a>
8010684a:	66 90                	xchg   %ax,%ax
			pick = s;
	}
	//cprintf("\n");
	//if(i == 0) cprintf("no valid stride!\n");
	if(pick == s_cand){
8010684c:	81 fb c0 57 11 80    	cmp    $0x801157c0,%ebx
80106852:	74 06                	je     8010685a <pick_pass+0x4e>

		//cprintf("case 3 : stride = %d, pass = %d, pri = %d\n", s_cand[0].stride, s_cand[0].pass, mlfq_proc->prior);
		return mlfq_proc;
	}
	//cprintf("case 2 : stride = %d, pass = %d\n", pick->stride, pick->pass);
	return pick->proc;
80106854:	8b 43 10             	mov    0x10(%ebx),%eax
}
80106857:	5b                   	pop    %ebx
80106858:	5d                   	pop    %ebp
80106859:	c3                   	ret    
		struct proc* mlfq_proc = pick_MLFQ();
8010685a:	e8 c1 fe ff ff       	call   80106720 <pick_MLFQ>
		if(mlfq_proc == 0){
8010685f:	85 c0                	test   %eax,%eax
80106861:	75 f4                	jne    80106857 <pick_pass+0x4b>
80106863:	b9 00 84 d7 17       	mov    $0x17d78400,%ecx
80106868:	b8 d4 57 11 80       	mov    $0x801157d4,%eax
8010686d:	eb 0b                	jmp    8010687a <pick_pass+0x6e>
8010686f:	90                   	nop
			for(s = &s_cand[1]; s < &s_cand[NPROC]; s++){
80106870:	83 c0 14             	add    $0x14,%eax
80106873:	3d c0 5c 11 80       	cmp    $0x80115cc0,%eax
80106878:	74 da                	je     80106854 <pick_pass+0x48>
				if(s->valid == 0)
8010687a:	8b 50 0c             	mov    0xc(%eax),%edx
8010687d:	85 d2                	test   %edx,%edx
8010687f:	74 ef                	je     80106870 <pick_pass+0x64>
				if(s->proc->state != RUNNABLE)
80106881:	8b 50 10             	mov    0x10(%eax),%edx
80106884:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80106888:	75 e6                	jne    80106870 <pick_pass+0x64>
				if(s->pass < min){
8010688a:	8b 50 04             	mov    0x4(%eax),%edx
8010688d:	39 ca                	cmp    %ecx,%edx
8010688f:	73 df                	jae    80106870 <pick_pass+0x64>
80106891:	89 d1                	mov    %edx,%ecx
80106893:	89 c3                	mov    %eax,%ebx
80106895:	eb d9                	jmp    80106870 <pick_pass+0x64>
80106897:	90                   	nop

80106898 <scheduler>:
//      via swtch back to the scheduler.


void
scheduler(void)
{
80106898:	55                   	push   %ebp
80106899:	89 e5                	mov    %esp,%ebp
8010689b:	57                   	push   %edi
8010689c:	56                   	push   %esi
8010689d:	53                   	push   %ebx
8010689e:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p;
  struct proc *win;
  struct cpu *c = mycpu();
801068a1:	e8 42 c9 ff ff       	call   801031e8 <mycpu>
801068a6:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801068a8:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801068af:	00 00 00 
801068b2:	8d 78 04             	lea    0x4(%eax),%edi
801068b5:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801068b8:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801068b9:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801068c0:	e8 bb d3 ff ff       	call   80103c80 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801068c5:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801068ca:	eb 0e                	jmp    801068da <scheduler+0x42>
801068cc:	81 c3 88 00 00 00    	add    $0x88,%ebx
801068d2:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
801068d8:	74 56                	je     80106930 <scheduler+0x98>
      if(p->state != RUNNABLE)
801068da:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801068de:	75 ec                	jne    801068cc <scheduler+0x34>
        continue;

      
      ///패스에 의해서 하나를 뽑아야함
      //cprintf("pick_pass called\n");
      win = pick_pass();
801068e0:	e8 27 ff ff ff       	call   8010680c <pick_pass>
      if(win == 0){
801068e5:	85 c0                	test   %eax,%eax
801068e7:	74 58                	je     80106941 <scheduler+0xa9>
      }
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      //cprintf("%d : %s (pid:%d, ticks:%d, state:%d, level:%d)\n", ticks, win->name, win->pid, win->pticks, win->state, win->prior);
      c->proc = win;
801068e9:	89 86 ac 00 00 00    	mov    %eax,0xac(%esi)
      switchuvm(win);
801068ef:	89 04 24             	mov    %eax,(%esp)
801068f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801068f5:	e8 56 f5 ff ff       	call   80105e50 <switchuvm>
      win->state = RUNNING;
801068fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068fd:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), win->context);
80106904:	8b 40 1c             	mov    0x1c(%eax),%eax
80106907:	89 44 24 04          	mov    %eax,0x4(%esp)
8010690b:	89 3c 24             	mov    %edi,(%esp)
8010690e:	e8 52 d6 ff ff       	call   80103f65 <swtch>
      //myproc()->pticks++;
      switchkvm();
80106913:	e8 24 f5 ff ff       	call   80105e3c <switchkvm>
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80106918:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
8010691f:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80106922:	81 c3 88 00 00 00    	add    $0x88,%ebx
80106928:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
8010692e:	75 aa                	jne    801068da <scheduler+0x42>
    }
    release(&ptable.lock);
80106930:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80106937:	e8 00 d4 ff ff       	call   80103d3c <release>

  }
8010693c:	e9 77 ff ff ff       	jmp    801068b8 <scheduler+0x20>
      	cprintf("fatal pick\n");
80106941:	c7 04 24 04 76 10 80 	movl   $0x80107604,(%esp)
80106948:	e8 67 9c ff ff       	call   801005b4 <cprintf>
8010694d:	89 d8                	mov    %ebx,%eax
8010694f:	eb 98                	jmp    801068e9 <scheduler+0x51>
80106951:	8d 76 00             	lea    0x0(%esi),%esi

80106954 <set_cpu_share>:
}

int
set_cpu_share(int inquire)
{	
80106954:	55                   	push   %ebp
80106955:	89 e5                	mov    %esp,%ebp
80106957:	57                   	push   %edi
80106958:	56                   	push   %esi
80106959:	53                   	push   %ebx
8010695a:	83 ec 0c             	sub    $0xc,%esp
8010695d:	8b 75 08             	mov    0x8(%ebp),%esi

	if(inquire <= 0)
80106960:	85 f6                	test   %esi,%esi
80106962:	0f 8e 0e 01 00 00    	jle    80106a76 <set_cpu_share+0x122>
		return -1;
	if(myproc()->myst != s_cand){
80106968:	e8 23 c9 ff ff       	call   80103290 <myproc>
8010696d:	81 b8 84 00 00 00 c0 	cmpl   $0x801157c0,0x84(%eax)
80106974:	57 11 80 
80106977:	0f 85 f9 00 00 00    	jne    80106a76 <set_cpu_share+0x122>
8010697d:	89 f3                	mov    %esi,%ebx
8010697f:	b9 00 84 d7 17       	mov    $0x17d78400,%ecx
80106984:	b8 c0 57 11 80       	mov    $0x801157c0,%eax
80106989:	eb 0b                	jmp    80106996 <set_cpu_share+0x42>
8010698b:	90                   	nop
		return -1;
	}
	struct stride* s;
	uint min_pass = 400000000;
	int sum = inquire;
	for(s = s_cand; s < &s_cand[NPROC]; s++){
8010698c:	83 c0 14             	add    $0x14,%eax
8010698f:	3d c0 5c 11 80       	cmp    $0x80115cc0,%eax
80106994:	73 1e                	jae    801069b4 <set_cpu_share+0x60>
		if(s->valid == 1){
80106996:	83 78 0c 01          	cmpl   $0x1,0xc(%eax)
8010699a:	75 f0                	jne    8010698c <set_cpu_share+0x38>
			sum += s->share;
8010699c:	03 58 08             	add    0x8(%eax),%ebx
			if(min_pass > s->pass)
8010699f:	8b 50 04             	mov    0x4(%eax),%edx
801069a2:	39 ca                	cmp    %ecx,%edx
801069a4:	73 e6                	jae    8010698c <set_cpu_share+0x38>
801069a6:	89 d1                	mov    %edx,%ecx
	for(s = s_cand; s < &s_cand[NPROC]; s++){
801069a8:	83 c0 14             	add    $0x14,%eax
801069ab:	3d c0 5c 11 80       	cmp    $0x80115cc0,%eax
801069b0:	72 e4                	jb     80106996 <set_cpu_share+0x42>
801069b2:	66 90                	xchg   %ax,%ax
				min_pass = s->pass;
		}
	}
	sum -= s_cand[0].share;
801069b4:	2b 1d c8 57 11 80    	sub    0x801157c8,%ebx
	if(sum > 80)
801069ba:	83 fb 50             	cmp    $0x50,%ebx
801069bd:	0f 8f b3 00 00 00    	jg     80106a76 <set_cpu_share+0x122>
		return -1;

	s_cand[0].share = (100 - sum);
801069c3:	bf 64 00 00 00       	mov    $0x64,%edi
801069c8:	29 df                	sub    %ebx,%edi
801069ca:	89 3d c8 57 11 80    	mov    %edi,0x801157c8
	s_cand[0].stride = 10000000 / s_cand[0].share;
801069d0:	b8 80 96 98 00       	mov    $0x989680,%eax
801069d5:	99                   	cltd   
801069d6:	f7 ff                	idiv   %edi
801069d8:	a3 c0 57 11 80       	mov    %eax,0x801157c0
	

	for(s = s_cand; s < &s_cand[NPROC]; s++){
801069dd:	bb c0 57 11 80       	mov    $0x801157c0,%ebx
801069e2:	eb 0b                	jmp    801069ef <set_cpu_share+0x9b>
801069e4:	83 c3 14             	add    $0x14,%ebx
801069e7:	81 fb c0 5c 11 80    	cmp    $0x80115cc0,%ebx
801069ed:	73 07                	jae    801069f6 <set_cpu_share+0xa2>
		if(s->valid == 0)
801069ef:	8b 7b 0c             	mov    0xc(%ebx),%edi
801069f2:	85 ff                	test   %edi,%edi
801069f4:	75 ee                	jne    801069e4 <set_cpu_share+0x90>
			break;
	}
	s->share = inquire;
801069f6:	89 73 08             	mov    %esi,0x8(%ebx)
	s->stride = 10000000 / inquire;
801069f9:	b8 80 96 98 00       	mov    $0x989680,%eax
801069fe:	99                   	cltd   
801069ff:	f7 fe                	idiv   %esi
80106a01:	89 03                	mov    %eax,(%ebx)
	s->pass = min_pass;
80106a03:	89 4b 04             	mov    %ecx,0x4(%ebx)
	struct proc* p = myproc();
80106a06:	e8 85 c8 ff ff       	call   80103290 <myproc>
	s->proc = p;
80106a0b:	89 43 10             	mov    %eax,0x10(%ebx)
	p->myst = s;
80106a0e:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
	int prior = p->prior;
80106a14:	8b 70 7c             	mov    0x7c(%eax),%esi
set_cpu_share(int inquire)
80106a17:	89 f2                	mov    %esi,%edx
80106a19:	c1 e2 08             	shl    $0x8,%edx
80106a1c:	8d 0c f2             	lea    (%edx,%esi,8),%ecx
	for(i = 0; i < NPROC; i++){
80106a1f:	31 d2                	xor    %edx,%edx
80106a21:	eb 07                	jmp    80106a2a <set_cpu_share+0xd6>
80106a23:	90                   	nop
80106a24:	42                   	inc    %edx
80106a25:	83 fa 40             	cmp    $0x40,%edx
80106a28:	74 34                	je     80106a5e <set_cpu_share+0x10a>
		if(MLFQ_table[prior].wait[i] == p){
80106a2a:	3b 84 91 c8 5c 11 80 	cmp    -0x7feea338(%ecx,%edx,4),%eax
80106a31:	75 f1                	jne    80106a24 <set_cpu_share+0xd0>
			MLFQ_table[prior].wait[i] = 0;
80106a33:	89 f1                	mov    %esi,%ecx
80106a35:	c1 e1 06             	shl    $0x6,%ecx
80106a38:	8d 0c 71             	lea    (%ecx,%esi,2),%ecx
80106a3b:	01 ca                	add    %ecx,%edx
80106a3d:	c7 04 95 c8 5c 11 80 	movl   $0x0,-0x7feea338(,%edx,4)
80106a44:	00 00 00 00 
			p->pticks = 0;
80106a48:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80106a4f:	00 00 00 
			MLFQ_table[prior].total--;
80106a52:	89 f2                	mov    %esi,%edx
80106a54:	c1 e2 08             	shl    $0x8,%edx
80106a57:	ff 8c f2 c0 5c 11 80 	decl   -0x7feea340(%edx,%esi,8)
	pop_MLFQ(p);
	p->prior = 3;
80106a5e:	c7 40 7c 03 00 00 00 	movl   $0x3,0x7c(%eax)
	s->valid = 1;
80106a65:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
	return 0;
80106a6c:	31 c0                	xor    %eax,%eax
}
80106a6e:	83 c4 0c             	add    $0xc,%esp
80106a71:	5b                   	pop    %ebx
80106a72:	5e                   	pop    %esi
80106a73:	5f                   	pop    %edi
80106a74:	5d                   	pop    %ebp
80106a75:	c3                   	ret    
		return -1;
80106a76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106a7b:	83 c4 0c             	add    $0xc,%esp
80106a7e:	5b                   	pop    %ebx
80106a7f:	5e                   	pop    %esi
80106a80:	5f                   	pop    %edi
80106a81:	5d                   	pop    %ebp
80106a82:	c3                   	ret    
80106a83:	90                   	nop

80106a84 <stride_adder>:

void
stride_adder(int step)
{
80106a84:	55                   	push   %ebp
80106a85:	89 e5                	mov    %esp,%ebp
80106a87:	56                   	push   %esi
80106a88:	53                   	push   %ebx
80106a89:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct stride* s = myproc()->myst;
80106a8c:	e8 ff c7 ff ff       	call   80103290 <myproc>
80106a91:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
	int i;
	for(i = 0; i < step; i++){
80106a97:	85 db                	test   %ebx,%ebx
80106a99:	7e 36                	jle    80106ad1 <stride_adder+0x4d>
80106a9b:	8b 08                	mov    (%eax),%ecx
stride_adder(int step)
80106a9d:	8b 70 04             	mov    0x4(%eax),%esi
80106aa0:	01 ce                	add    %ecx,%esi
80106aa2:	8d 53 ff             	lea    -0x1(%ebx),%edx
80106aa5:	0f af d1             	imul   %ecx,%edx
80106aa8:	01 f2                	add    %esi,%edx
80106aaa:	89 50 04             	mov    %edx,0x4(%eax)
		s->pass += s->stride;
	}
	if(s->pass > 300000000){
80106aad:	81 fa 00 a3 e1 11    	cmp    $0x11e1a300,%edx
80106ab3:	7e 18                	jle    80106acd <stride_adder+0x49>
80106ab5:	b8 c0 57 11 80       	mov    $0x801157c0,%eax
80106aba:	66 90                	xchg   %ax,%ax
		for(s = s_cand; s < &s_cand[NPROC]; s++){
			s->pass = 0;
80106abc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		for(s = s_cand; s < &s_cand[NPROC]; s++){
80106ac3:	83 c0 14             	add    $0x14,%eax
80106ac6:	3d c0 5c 11 80       	cmp    $0x80115cc0,%eax
80106acb:	72 ef                	jb     80106abc <stride_adder+0x38>
		}
	}
}
80106acd:	5b                   	pop    %ebx
80106ace:	5e                   	pop    %esi
80106acf:	5d                   	pop    %ebp
80106ad0:	c3                   	ret    
80106ad1:	8b 50 04             	mov    0x4(%eax),%edx
80106ad4:	eb d7                	jmp    80106aad <stride_adder+0x29>
80106ad6:	66 90                	xchg   %ax,%ax

80106ad8 <MLFQ_tick_adder>:

int
MLFQ_tick_adder(void)
{
80106ad8:	55                   	push   %ebp
80106ad9:	89 e5                	mov    %esp,%ebp
80106adb:	56                   	push   %esi
80106adc:	53                   	push   %ebx
80106add:	83 ec 10             	sub    $0x10,%esp
	acquire(&ptable.lock);
80106ae0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80106ae7:	e8 94 d1 ff ff       	call   80103c80 <acquire>
	stride_adder(1);
80106aec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106af3:	e8 8c ff ff ff       	call   80106a84 <stride_adder>
	struct proc* p = myproc();
80106af8:	e8 93 c7 ff ff       	call   80103290 <myproc>
	if(p->prior ==3){
80106afd:	8b 50 7c             	mov    0x7c(%eax),%edx
80106b00:	83 fa 03             	cmp    $0x3,%edx
80106b03:	74 51                	je     80106b56 <MLFQ_tick_adder+0x7e>
		release(&ptable.lock);
		return 1;
	}
	
	global_ticks++;
80106b05:	8b 0d a8 a5 10 80    	mov    0x8010a5a8,%ecx
80106b0b:	41                   	inc    %ecx
80106b0c:	89 0d a8 a5 10 80    	mov    %ecx,0x8010a5a8
	
	int quantum = p->pticks;
80106b12:	8b 98 80 00 00 00    	mov    0x80(%eax),%ebx
	p->pticks++;
80106b18:	8d 73 01             	lea    0x1(%ebx),%esi
80106b1b:	89 b0 80 00 00 00    	mov    %esi,0x80(%eax)
	//cprintf("now %d and qunt %d\n", p->prior, quantum);
	switch(p->prior){
80106b21:	83 fa 01             	cmp    $0x1,%edx
80106b24:	74 76                	je     80106b9c <MLFQ_tick_adder+0xc4>
80106b26:	72 20                	jb     80106b48 <MLFQ_tick_adder+0x70>
80106b28:	83 fa 02             	cmp    $0x2,%edx
80106b2b:	74 43                	je     80106b70 <MLFQ_tick_adder+0x98>
				release(&ptable.lock);
				return 0;
			}
			break;
		default:
			release(&ptable.lock);
80106b2d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80106b34:	e8 03 d2 ff ff       	call   80103d3c <release>
			return -1;
80106b39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}	
}
80106b3e:	83 c4 10             	add    $0x10,%esp
80106b41:	5b                   	pop    %ebx
80106b42:	5e                   	pop    %esi
80106b43:	5d                   	pop    %ebp
80106b44:	c3                   	ret    
80106b45:	8d 76 00             	lea    0x0(%esi),%esi
			if(quantum >= 5){
80106b48:	83 fb 04             	cmp    $0x4,%ebx
80106b4b:	0f 8f 83 00 00 00    	jg     80106bd4 <MLFQ_tick_adder+0xfc>
			if(global_ticks > 100){	
80106b51:	83 f9 64             	cmp    $0x64,%ecx
80106b54:	7f 76                	jg     80106bcc <MLFQ_tick_adder+0xf4>
		release(&ptable.lock);
80106b56:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80106b5d:	e8 da d1 ff ff       	call   80103d3c <release>
		return 1;
80106b62:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106b67:	83 c4 10             	add    $0x10,%esp
80106b6a:	5b                   	pop    %ebx
80106b6b:	5e                   	pop    %esi
80106b6c:	5d                   	pop    %ebp
80106b6d:	c3                   	ret    
80106b6e:	66 90                	xchg   %ax,%ax
			if((quantum % 4) == 0){
80106b70:	83 e3 03             	and    $0x3,%ebx
80106b73:	0f 85 8b 00 00 00    	jne    80106c04 <MLFQ_tick_adder+0x12c>
				if(global_ticks > 100){	
80106b79:	83 f9 64             	cmp    $0x64,%ecx
80106b7c:	7e 05                	jle    80106b83 <MLFQ_tick_adder+0xab>
					prior_boost();
80106b7e:	e8 39 fc ff ff       	call   801067bc <prior_boost>
				release(&ptable.lock);
80106b83:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80106b8a:	e8 ad d1 ff ff       	call   80103d3c <release>
				return 4;
80106b8f:	b8 04 00 00 00       	mov    $0x4,%eax
}
80106b94:	83 c4 10             	add    $0x10,%esp
80106b97:	5b                   	pop    %ebx
80106b98:	5e                   	pop    %esi
80106b99:	5d                   	pop    %ebp
80106b9a:	c3                   	ret    
80106b9b:	90                   	nop
			if(quantum >= 10){
80106b9c:	83 fb 09             	cmp    $0x9,%ebx
80106b9f:	7f 4f                	jg     80106bf0 <MLFQ_tick_adder+0x118>
			if((quantum % 2) == 0){
80106ba1:	83 e3 01             	and    $0x1,%ebx
80106ba4:	75 5e                	jne    80106c04 <MLFQ_tick_adder+0x12c>
				if(global_ticks > 100){	
80106ba6:	83 3d a8 a5 10 80 64 	cmpl   $0x64,0x8010a5a8
80106bad:	7e 05                	jle    80106bb4 <MLFQ_tick_adder+0xdc>
					prior_boost();
80106baf:	e8 08 fc ff ff       	call   801067bc <prior_boost>
				release(&ptable.lock);
80106bb4:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80106bbb:	e8 7c d1 ff ff       	call   80103d3c <release>
				return 2;
80106bc0:	b8 02 00 00 00       	mov    $0x2,%eax
}
80106bc5:	83 c4 10             	add    $0x10,%esp
80106bc8:	5b                   	pop    %ebx
80106bc9:	5e                   	pop    %esi
80106bca:	5d                   	pop    %ebp
80106bcb:	c3                   	ret    
				prior_boost();
80106bcc:	e8 eb fb ff ff       	call   801067bc <prior_boost>
80106bd1:	eb 83                	jmp    80106b56 <MLFQ_tick_adder+0x7e>
80106bd3:	90                   	nop
				move_MLFQ_prior(1, p);
80106bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bd8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106bdf:	e8 78 fa ff ff       	call   8010665c <move_MLFQ_prior>
80106be4:	8b 0d a8 a5 10 80    	mov    0x8010a5a8,%ecx
80106bea:	e9 62 ff ff ff       	jmp    80106b51 <MLFQ_tick_adder+0x79>
80106bef:	90                   	nop
				move_MLFQ_prior(2, p);
80106bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bf4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106bfb:	e8 5c fa ff ff       	call   8010665c <move_MLFQ_prior>
80106c00:	eb 9f                	jmp    80106ba1 <MLFQ_tick_adder+0xc9>
80106c02:	66 90                	xchg   %ax,%ax
				release(&ptable.lock);
80106c04:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80106c0b:	e8 2c d1 ff ff       	call   80103d3c <release>
				return 0;
80106c10:	31 c0                	xor    %eax,%eax
80106c12:	e9 27 ff ff ff       	jmp    80106b3e <MLFQ_tick_adder+0x66>
