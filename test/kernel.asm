
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
8010004a:	e8 79 3b 00 00       	call   80103bc8 <initlock>

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
8010008a:	e8 49 3a 00 00       	call   80103ad8 <initsleeplock>
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
801000ca:	e8 c1 3b 00 00       	call   80103c90 <acquire>
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
8010013d:	e8 0a 3c 00 00       	call   80103d4c <release>
      acquiresleep(&b->lock);
80100142:	8d 43 0c             	lea    0xc(%ebx),%eax
80100145:	89 04 24             	mov    %eax,(%esp)
80100148:	e8 c3 39 00 00       	call   80103b10 <acquiresleep>
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
80100180:	e8 17 3a 00 00       	call   80103b9c <holdingsleep>
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
801001b9:	e8 de 39 00 00       	call   80103b9c <holdingsleep>
801001be:	85 c0                	test   %eax,%eax
801001c0:	74 5a                	je     8010021c <brelse+0x74>
    panic("brelse");

  releasesleep(&b->lock);
801001c2:	89 34 24             	mov    %esi,(%esp)
801001c5:	e8 96 39 00 00       	call   80103b60 <releasesleep>

  acquire(&bcache.lock);
801001ca:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
801001d1:	e8 ba 3a 00 00       	call   80103c90 <acquire>
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
80100217:	e9 30 3b 00 00       	jmp    80103d4c <release>
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
80100246:	e8 45 3a 00 00       	call   80103c90 <acquire>
  while(n > 0){
8010024b:	89 de                	mov    %ebx,%esi
8010024d:	85 db                	test   %ebx,%ebx
8010024f:	7f 27                	jg     80100278 <consoleread+0x50>
80100251:	e9 b6 00 00 00       	jmp    8010030c <consoleread+0xe4>
80100256:	66 90                	xchg   %ax,%ax
    while(input.r == input.w){
      if(myproc()->killed){
80100258:	e8 bb 30 00 00       	call   80103318 <myproc>
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
80100273:	e8 84 35 00 00       	call   801037fc <sleep>
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
801002bc:	e8 8b 3a 00 00       	call   80103d4c <release>
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
801002df:	e8 68 3a 00 00       	call   80103d4c <release>
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
8010035c:	e8 83 38 00 00       	call   80103be4 <getcallerpcs>
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
801003b5:	e8 66 4d 00 00       	call   80105120 <uartputc>
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
8010045a:	e8 c1 4c 00 00       	call   80105120 <uartputc>
8010045f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100466:	e8 b5 4c 00 00       	call   80105120 <uartputc>
8010046b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100472:	e8 a9 4c 00 00       	call   80105120 <uartputc>
80100477:	e9 3e ff ff ff       	jmp    801003ba <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010047c:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
80100483:	00 
80100484:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
8010048b:	80 
8010048c:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
80100493:	e8 90 39 00 00       	call   80103e28 <memmove>
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
801004ba:	e8 d5 38 00 00       	call   80103d94 <memset>
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
80100512:	e8 79 37 00 00       	call   80103c90 <acquire>
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
80100538:	e8 0f 38 00 00       	call   80103d4c <release>
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
8010066a:	e8 dd 36 00 00       	call   80103d4c <release>
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
801006df:	e8 ac 35 00 00       	call   80103c90 <acquire>
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
80100713:	e8 78 35 00 00       	call   80103c90 <acquire>
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
801007a5:	e8 d2 31 00 00       	call   8010397c <wakeup>
  while((c = getc()) >= 0){
801007aa:	ff d3                	call   *%ebx
801007ac:	89 c7                	mov    %eax,%edi
801007ae:	85 c0                	test   %eax,%eax
801007b0:	0f 89 72 ff ff ff    	jns    80100728 <consoleintr+0x28>
801007b6:	66 90                	xchg   %ax,%ax
  release(&cons.lock);
801007b8:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007bf:	e8 88 35 00 00       	call   80103d4c <release>
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
80100863:	e9 bc 31 00 00       	jmp    80103a24 <procdump>
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
801008a1:	e8 22 33 00 00       	call   80103bc8 <initlock>

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
801008e8:	e8 2b 2a 00 00       	call   80103318 <myproc>
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
80100964:	e8 87 59 00 00       	call   801062f0 <setupkvm>
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
80100a10:	e8 37 57 00 00       	call   8010614c <allocuvm>
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
80100a51:	e8 92 55 00 00       	call   80105fe8 <loaduvm>
80100a56:	85 c0                	test   %eax,%eax
80100a58:	0f 89 42 ff ff ff    	jns    801009a0 <exec+0xc4>
80100a5e:	66 90                	xchg   %ax,%ax
    freevm(pgdir);
80100a60:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100a66:	89 04 24             	mov    %eax,(%esp)
80100a69:	e8 0e 58 00 00       	call   8010627c <freevm>
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
80100aad:	e8 9a 56 00 00       	call   8010614c <allocuvm>
80100ab2:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100ab8:	85 c0                	test   %eax,%eax
80100aba:	75 33                	jne    80100aef <exec+0x213>
    freevm(pgdir);
80100abc:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ac2:	89 04 24             	mov    %eax,(%esp)
80100ac5:	e8 b2 57 00 00       	call   8010627c <freevm>
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
80100b07:	e8 78 58 00 00       	call   80106384 <clearpteu>
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
80100b3b:	e8 1c 34 00 00       	call   80103f5c <strlen>
80100b40:	f7 d0                	not    %eax
80100b42:	01 c3                	add    %eax,%ebx
80100b44:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100b4a:	8b 01                	mov    (%ecx),%eax
80100b4c:	89 04 24             	mov    %eax,(%esp)
80100b4f:	e8 08 34 00 00       	call   80103f5c <strlen>
80100b54:	40                   	inc    %eax
80100b55:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100b59:	8b 55 0c             	mov    0xc(%ebp),%edx
80100b5c:	8b 02                	mov    (%edx),%eax
80100b5e:	89 44 24 08          	mov    %eax,0x8(%esp)
80100b62:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100b66:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b6c:	89 04 24             	mov    %eax,(%esp)
80100b6f:	e8 44 59 00 00       	call   801064b8 <copyout>
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
80100be3:	e8 d0 58 00 00       	call   801064b8 <copyout>
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
80100c25:	e8 02 33 00 00       	call   80103f2c <safestrcpy>
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
80100c53:	e8 14 52 00 00       	call   80105e6c <switchuvm>
  freevm(oldpgdir);
80100c58:	89 34 24             	mov    %esi,(%esp)
80100c5b:	e8 1c 56 00 00       	call   8010627c <freevm>
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
80100c91:	e8 32 2f 00 00       	call   80103bc8 <initlock>
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
80100ca6:	e8 e5 2f 00 00       	call   80103c90 <acquire>
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
80100cd4:	e8 73 30 00 00       	call   80103d4c <release>
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
80100ceb:	e8 5c 30 00 00       	call   80103d4c <release>
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
80100d0d:	e8 7e 2f 00 00       	call   80103c90 <acquire>
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
80100d24:	e8 23 30 00 00       	call   80103d4c <release>
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
80100d53:	e8 38 2f 00 00       	call   80103c90 <acquire>
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
80100d79:	e9 ce 2f 00 00       	jmp    80103d4c <release>
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
80100d9e:	e8 a9 2f 00 00       	call   80103d4c <release>
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
80101004:	e8 87 2c 00 00       	call   80103c90 <acquire>

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
80101042:	e8 05 2d 00 00       	call   80103d4c <release>
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
80101086:	e8 c1 2c 00 00       	call   80103d4c <release>
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
8010118f:	e8 00 2c 00 00       	call   80103d94 <memset>
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
80101292:	e8 91 2b 00 00       	call   80103e28 <memmove>
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
80101342:	e8 81 28 00 00       	call   80103bc8 <initlock>
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
80101362:	e8 71 27 00 00       	call   80103ad8 <initsleeplock>
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
8010145b:	e8 34 29 00 00       	call   80103d94 <memset>
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
80101504:	e8 1f 29 00 00       	call   80103e28 <memmove>
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
80101531:	e8 5a 27 00 00       	call   80103c90 <acquire>
  ip->ref++;
80101536:	ff 43 08             	incl   0x8(%ebx)
  release(&icache.lock);
80101539:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101540:	e8 07 28 00 00       	call   80103d4c <release>
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
80101574:	e8 97 25 00 00       	call   80103b10 <acquiresleep>
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
801015e9:	e8 3a 28 00 00       	call   80103e28 <memmove>
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
80101635:	e8 62 25 00 00       	call   80103b9c <holdingsleep>
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
8010164e:	e9 0d 25 00 00       	jmp    80103b60 <releasesleep>
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
80101672:	e8 99 24 00 00       	call   80103b10 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101677:	8b 46 4c             	mov    0x4c(%esi),%eax
8010167a:	85 c0                	test   %eax,%eax
8010167c:	74 07                	je     80101685 <iput+0x25>
8010167e:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101683:	74 2b                	je     801016b0 <iput+0x50>
  releasesleep(&ip->lock);
80101685:	89 3c 24             	mov    %edi,(%esp)
80101688:	e8 d3 24 00 00       	call   80103b60 <releasesleep>
  acquire(&icache.lock);
8010168d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101694:	e8 f7 25 00 00       	call   80103c90 <acquire>
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
801016aa:	e9 9d 26 00 00       	jmp    80103d4c <release>
801016af:	90                   	nop
    acquire(&icache.lock);
801016b0:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016b7:	e8 d4 25 00 00       	call   80103c90 <acquire>
    int r = ip->ref;
801016bc:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
801016bf:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016c6:	e8 81 26 00 00       	call   80103d4c <release>
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
8010188b:	e8 98 25 00 00       	call   80103e28 <memmove>
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
80101996:	e8 8d 24 00 00       	call   80103e28 <memmove>
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
80101a2f:	e8 64 24 00 00       	call   80103e98 <strncmp>
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
80101b01:	e8 12 18 00 00       	call   80103318 <myproc>
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
80101b62:	e8 c1 22 00 00       	call   80103e28 <memmove>
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
80101bd9:	e8 4a 22 00 00       	call   80103e28 <memmove>
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
80101ccd:	e8 1a 22 00 00       	call   80103eec <strncpy>
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
80101e11:	e8 b2 1d 00 00       	call   80103bc8 <initlock>
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
80101e7c:	e8 0f 1e 00 00       	call   80103c90 <acquire>
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
80101ea8:	e8 cf 1a 00 00       	call   8010397c <wakeup>
  if(idequeue != 0)
80101ead:	a1 98 a5 10 80       	mov    0x8010a598,%eax
80101eb2:	85 c0                	test   %eax,%eax
80101eb4:	74 05                	je     80101ebb <ideintr+0x4f>
    idestart(idequeue);
80101eb6:	e8 99 fe ff ff       	call   80101d54 <idestart>
    release(&idelock);
80101ebb:	c7 04 24 60 a5 10 80 	movl   $0x8010a560,(%esp)
80101ec2:	e8 85 1e 00 00       	call   80103d4c <release>
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
80101f0c:	e8 8b 1c 00 00       	call   80103b9c <holdingsleep>
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
80101f42:	e8 49 1d 00 00       	call   80103c90 <acquire>
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
80101f87:	e8 70 18 00 00       	call   801037fc <sleep>
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
80101fa2:	e9 a5 1d 00 00       	jmp    80103d4c <release>
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
801020c2:	81 fb 1c 60 11 80    	cmp    $0x8011601c,%ebx
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
801020ea:	e8 a5 1c 00 00       	call   80103d94 <memset>

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
80102124:	e9 23 1c 00 00       	jmp    80103d4c <release>
80102129:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
8010212c:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102133:	e8 58 1b 00 00       	call   80103c90 <acquire>
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
801021c9:	e8 fa 19 00 00       	call   80103bc8 <initlock>
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
80102222:	e8 25 1b 00 00       	call   80103d4c <release>
80102227:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010222a:	c9                   	leave  
8010222b:	c3                   	ret    
    acquire(&kmem.lock);
8010222c:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102233:	e8 58 1a 00 00       	call   80103c90 <acquire>
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
80102574:	e8 67 18 00 00       	call   80103de0 <memcmp>
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
80102676:	e8 ad 17 00 00       	call   80103e28 <memmove>
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
8010271a:	e8 a9 14 00 00       	call   80103bc8 <initlock>
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
801027a5:	e8 e6 14 00 00       	call   80103c90 <acquire>
801027aa:	eb 14                	jmp    801027c0 <begin_op+0x28>
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
801027ac:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
801027b3:	80 
801027b4:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801027bb:	e8 3c 10 00 00       	call   801037fc <sleep>
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
801027ed:	e8 5a 15 00 00       	call   80103d4c <release>
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
80102804:	e8 87 14 00 00       	call   80103c90 <acquire>
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
8010283b:	e8 0c 15 00 00       	call   80103d4c <release>
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
8010289a:	e8 89 15 00 00       	call   80103e28 <memmove>
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
801028e0:	e8 ab 13 00 00       	call   80103c90 <acquire>
    log.committing = 0;
801028e5:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
801028ec:	00 00 00 
    wakeup(&log);
801028ef:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
801028f6:	e8 81 10 00 00       	call   8010397c <wakeup>
    release(&log.lock);
801028fb:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102902:	e8 45 14 00 00       	call   80103d4c <release>
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
8010294f:	e8 3c 13 00 00       	call   80103c90 <acquire>
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
8010299b:	e9 ac 13 00 00       	jmp    80103d4c <release>
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
801029d7:	e8 08 09 00 00       	call   801032e4 <cpuid>
801029dc:	89 c3                	mov    %eax,%ebx
801029de:	e8 01 09 00 00       	call   801032e4 <cpuid>
801029e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
801029e7:	89 44 24 04          	mov    %eax,0x4(%esp)
801029eb:	c7 04 24 f4 70 10 80 	movl   $0x801070f4,(%esp)
801029f2:	e8 bd db ff ff       	call   801005b4 <cprintf>
  idtinit();       // load idt register
801029f7:	e8 7c 24 00 00       	call   80104e78 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801029fc:	e8 6f 08 00 00       	call   80103270 <mycpu>
80102a01:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102a03:	b8 01 00 00 00       	mov    $0x1,%eax
80102a08:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102a0f:	e8 bc 3e 00 00       	call   801068d0 <scheduler>

80102a14 <mpenter>:
{
80102a14:	55                   	push   %ebp
80102a15:	89 e5                	mov    %esp,%ebp
80102a17:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102a1a:	e8 39 34 00 00       	call   80105e58 <switchkvm>
  seginit();
80102a1f:	e8 58 33 00 00       	call   80105d7c <seginit>
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
80102a42:	c7 04 24 1c 60 11 80 	movl   $0x8011601c,(%esp)
80102a49:	e8 5e f7 ff ff       	call   801021ac <kinit1>
  kvmalloc();      // kernel page table
80102a4e:	e8 15 39 00 00       	call   80106368 <kvmalloc>
  mpinit();        // detect other processors
80102a53:	e8 54 01 00 00       	call   80102bac <mpinit>
  lapicinit();     // interrupt controller
80102a58:	e8 1f f9 ff ff       	call   8010237c <lapicinit>
  seginit();       // segment descriptors
80102a5d:	e8 1a 33 00 00       	call   80105d7c <seginit>
  picinit();       // disable pic
80102a62:	e8 ed 02 00 00       	call   80102d54 <picinit>
  ioapicinit();    // another interrupt controller
80102a67:	e8 70 f5 ff ff       	call   80101fdc <ioapicinit>
  consoleinit();   // console hardware
80102a6c:	e8 1b de ff ff       	call   8010088c <consoleinit>
  uartinit();      // serial port
80102a71:	e8 f2 26 00 00       	call   80105168 <uartinit>
  pinit();         // process table
80102a76:	e8 d9 07 00 00       	call   80103254 <pinit>
  tvinit();        // trap vectors
80102a7b:	e8 70 23 00 00       	call   80104df0 <tvinit>
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
80102aa6:	e8 7d 13 00 00       	call   80103e28 <memmove>

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
80102ac8:	e8 a3 07 00 00       	call   80103270 <mycpu>
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
80102b43:	e8 f0 07 00 00       	call   80103338 <userinit>
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
80102b7b:	e8 60 12 00 00       	call   80103de0 <memcmp>
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
80102c23:	e8 b8 11 00 00       	call   80103de0 <memcmp>
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
80102ddb:	e8 e8 0d 00 00       	call   80103bc8 <initlock>
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
80102e65:	e8 26 0e 00 00       	call   80103c90 <acquire>
  if(writable){
80102e6a:	85 f6                	test   %esi,%esi
80102e6c:	74 3a                	je     80102ea8 <pipeclose+0x54>
    p->writeopen = 0;
80102e6e:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102e75:	00 00 00 
    wakeup(&p->nread);
80102e78:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e7e:	89 04 24             	mov    %eax,(%esp)
80102e81:	e8 f6 0a 00 00       	call   8010397c <wakeup>
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
80102ea3:	e9 a4 0e 00 00       	jmp    80103d4c <release>
    p->readopen = 0;
80102ea8:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102eaf:	00 00 00 
    wakeup(&p->nwrite);
80102eb2:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102eb8:	89 04 24             	mov    %eax,(%esp)
80102ebb:	e8 bc 0a 00 00       	call   8010397c <wakeup>
80102ec0:	eb c4                	jmp    80102e86 <pipeclose+0x32>
80102ec2:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80102ec4:	89 1c 24             	mov    %ebx,(%esp)
80102ec7:	e8 80 0e 00 00       	call   80103d4c <release>
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
80102eeb:	e8 a0 0d 00 00       	call   80103c90 <acquire>
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
80102f26:	e8 ed 03 00 00       	call   80103318 <myproc>
80102f2b:	8b 48 24             	mov    0x24(%eax),%ecx
80102f2e:	85 c9                	test   %ecx,%ecx
80102f30:	75 66                	jne    80102f98 <pipewrite+0xbc>
      wakeup(&p->nread);
80102f32:	89 3c 24             	mov    %edi,(%esp)
80102f35:	e8 42 0a 00 00       	call   8010397c <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102f3a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80102f3e:	89 34 24             	mov    %esi,(%esp)
80102f41:	e8 b6 08 00 00       	call   801037fc <sleep>
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
80102f88:	e8 ef 09 00 00       	call   8010397c <wakeup>
  release(&p->lock);
80102f8d:	89 1c 24             	mov    %ebx,(%esp)
80102f90:	e8 b7 0d 00 00       	call   80103d4c <release>
  return n;
80102f95:	eb 10                	jmp    80102fa7 <pipewrite+0xcb>
80102f97:	90                   	nop
        release(&p->lock);
80102f98:	89 1c 24             	mov    %ebx,(%esp)
80102f9b:	e8 ac 0d 00 00       	call   80103d4c <release>
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
80102fc3:	e8 c8 0c 00 00       	call   80103c90 <acquire>
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
80102fef:	e8 08 08 00 00       	call   801037fc <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102ff4:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80102ffa:	3b 8b 38 02 00 00    	cmp    0x238(%ebx),%ecx
80103000:	75 2e                	jne    80103030 <piperead+0x7c>
80103002:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103008:	85 c0                	test   %eax,%eax
8010300a:	74 24                	je     80103030 <piperead+0x7c>
    if(myproc()->killed){
8010300c:	e8 07 03 00 00       	call   80103318 <myproc>
80103011:	8b 40 24             	mov    0x24(%eax),%eax
80103014:	85 c0                	test   %eax,%eax
80103016:	74 d0                	je     80102fe8 <piperead+0x34>
      release(&p->lock);
80103018:	89 1c 24             	mov    %ebx,(%esp)
8010301b:	e8 2c 0d 00 00       	call   80103d4c <release>
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
80103081:	e8 f6 08 00 00       	call   8010397c <wakeup>
  release(&p->lock);
80103086:	89 1c 24             	mov    %ebx,(%esp)
80103089:	e8 be 0c 00 00       	call   80103d4c <release>
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

801030a0 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
801030a0:	55                   	push   %ebp
801030a1:	89 e5                	mov    %esp,%ebp
801030a3:	56                   	push   %esi
801030a4:	53                   	push   %ebx
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801030a5:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
801030aa:	eb 0e                	jmp    801030ba <wakeup1+0x1a>
801030ac:	81 c2 88 00 00 00    	add    $0x88,%edx
801030b2:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
801030b8:	74 6a                	je     80103124 <wakeup1+0x84>
    if(p->state == SLEEPING && p->chan == chan){
801030ba:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
801030be:	75 ec                	jne    801030ac <wakeup1+0xc>
801030c0:	39 42 20             	cmp    %eax,0x20(%edx)
801030c3:	75 e7                	jne    801030ac <wakeup1+0xc>
      p->state = RUNNABLE;
801030c5:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
      if(p->prior == 3){
801030cc:	83 7a 7c 03          	cmpl   $0x3,0x7c(%edx)
801030d0:	75 da                	jne    801030ac <wakeup1+0xc>
801030d2:	b9 00 58 11 80       	mov    $0x80115800,%ecx
801030d7:	be 00 a3 e1 11       	mov    $0x11e1a300,%esi
801030dc:	eb 0d                	jmp    801030eb <wakeup1+0x4b>
801030de:	66 90                	xchg   %ax,%ax
        uint min = 300000000;
        struct stride *s;
        for(s = s_cand; s < &s_cand[NPROC]; s++){
801030e0:	83 c1 14             	add    $0x14,%ecx
801030e3:	81 f9 00 5d 11 80    	cmp    $0x80115d00,%ecx
801030e9:	73 1d                	jae    80103108 <wakeup1+0x68>
          if(s->valid == 1){
801030eb:	83 79 0c 01          	cmpl   $0x1,0xc(%ecx)
801030ef:	75 ef                	jne    801030e0 <wakeup1+0x40>
            if(min > s->pass)
801030f1:	8b 59 04             	mov    0x4(%ecx),%ebx
801030f4:	39 de                	cmp    %ebx,%esi
801030f6:	76 e8                	jbe    801030e0 <wakeup1+0x40>
801030f8:	89 de                	mov    %ebx,%esi
        for(s = s_cand; s < &s_cand[NPROC]; s++){
801030fa:	83 c1 14             	add    $0x14,%ecx
801030fd:	81 f9 00 5d 11 80    	cmp    $0x80115d00,%ecx
80103103:	72 e6                	jb     801030eb <wakeup1+0x4b>
80103105:	8d 76 00             	lea    0x0(%esi),%esi
              min = s->pass;
          }
        }
        if(min > p->myst->pass){
80103108:	8b 8a 84 00 00 00    	mov    0x84(%edx),%ecx
8010310e:	39 71 04             	cmp    %esi,0x4(%ecx)
80103111:	73 99                	jae    801030ac <wakeup1+0xc>
          p->myst->pass = min;
80103113:	89 71 04             	mov    %esi,0x4(%ecx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103116:	81 c2 88 00 00 00    	add    $0x88,%edx
8010311c:	81 fa 54 4f 11 80    	cmp    $0x80114f54,%edx
80103122:	75 96                	jne    801030ba <wakeup1+0x1a>
        }
      }
    }
  }

}
80103124:	5b                   	pop    %ebx
80103125:	5e                   	pop    %esi
80103126:	5d                   	pop    %ebp
80103127:	c3                   	ret    

80103128 <allocproc>:
{
80103128:	55                   	push   %ebp
80103129:	89 e5                	mov    %esp,%ebp
8010312b:	53                   	push   %ebx
8010312c:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
8010312f:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103136:	e8 55 0b 00 00       	call   80103c90 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010313b:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103140:	eb 14                	jmp    80103156 <allocproc+0x2e>
80103142:	66 90                	xchg   %ax,%ax
80103144:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010314a:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103150:	0f 84 96 00 00 00    	je     801031ec <allocproc+0xc4>
    if(p->state == UNUSED)
80103156:	8b 43 0c             	mov    0xc(%ebx),%eax
80103159:	85 c0                	test   %eax,%eax
8010315b:	75 e7                	jne    80103144 <allocproc+0x1c>
  p->state = EMBRYO;
8010315d:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103164:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80103169:	89 43 10             	mov    %eax,0x10(%ebx)
8010316c:	40                   	inc    %eax
8010316d:	a3 00 a0 10 80       	mov    %eax,0x8010a000
  release(&ptable.lock);
80103172:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103179:	e8 ce 0b 00 00       	call   80103d4c <release>
  if((p->kstack = kalloc()) == 0){
8010317e:	e8 69 f0 ff ff       	call   801021ec <kalloc>
80103183:	89 43 08             	mov    %eax,0x8(%ebx)
80103186:	85 c0                	test   %eax,%eax
80103188:	74 78                	je     80103202 <allocproc+0xda>
  sp -= sizeof *p->tf;
8010318a:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
80103190:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103193:	c7 80 b0 0f 00 00 e5 	movl   $0x80104de5,0xfb0(%eax)
8010319a:	4d 10 80 
  sp -= sizeof *p->context;
8010319d:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
801031a2:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801031a5:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
801031ac:	00 
801031ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801031b4:	00 
801031b5:	89 04 24             	mov    %eax,(%esp)
801031b8:	e8 d7 0b 00 00       	call   80103d94 <memset>
  p->context->eip = (uint)forkret;
801031bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
801031c0:	c7 40 10 10 32 10 80 	movl   $0x80103210,0x10(%eax)
  push_MLFQ(0, p); // When process created, it pushed into MLFQ - project 2
801031c7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801031cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801031d2:	e8 d1 33 00 00       	call   801065a8 <push_MLFQ>
  p->myst = s_cand; // so its scheduler is determined by MLFQ, its stride is s_cand[0] - project 2
801031d7:	c7 83 84 00 00 00 00 	movl   $0x80115800,0x84(%ebx)
801031de:	58 11 80 
}
801031e1:	89 d8                	mov    %ebx,%eax
801031e3:	83 c4 14             	add    $0x14,%esp
801031e6:	5b                   	pop    %ebx
801031e7:	5d                   	pop    %ebp
801031e8:	c3                   	ret    
801031e9:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
801031ec:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801031f3:	e8 54 0b 00 00       	call   80103d4c <release>
  return 0;
801031f8:	31 db                	xor    %ebx,%ebx
}
801031fa:	89 d8                	mov    %ebx,%eax
801031fc:	83 c4 14             	add    $0x14,%esp
801031ff:	5b                   	pop    %ebx
80103200:	5d                   	pop    %ebp
80103201:	c3                   	ret    
    p->state = UNUSED;
80103202:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103209:	31 db                	xor    %ebx,%ebx
8010320b:	eb d4                	jmp    801031e1 <allocproc+0xb9>
8010320d:	8d 76 00             	lea    0x0(%esi),%esi

80103210 <forkret>:
{
80103210:	55                   	push   %ebp
80103211:	89 e5                	mov    %esp,%ebp
80103213:	83 ec 18             	sub    $0x18,%esp
  release(&ptable.lock);
80103216:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010321d:	e8 2a 0b 00 00       	call   80103d4c <release>
  if (first) {
80103222:	8b 15 04 a0 10 80    	mov    0x8010a004,%edx
80103228:	85 d2                	test   %edx,%edx
8010322a:	75 04                	jne    80103230 <forkret+0x20>
}
8010322c:	c9                   	leave  
8010322d:	c3                   	ret    
8010322e:	66 90                	xchg   %ax,%ax
    first = 0;
80103230:	c7 05 04 a0 10 80 00 	movl   $0x0,0x8010a004
80103237:	00 00 00 
    iinit(ROOTDEV);
8010323a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103241:	e8 e6 e0 ff ff       	call   8010132c <iinit>
    initlog(ROOTDEV);
80103246:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010324d:	e8 ae f4 ff ff       	call   80102700 <initlog>
}
80103252:	c9                   	leave  
80103253:	c3                   	ret    

80103254 <pinit>:
{
80103254:	55                   	push   %ebp
80103255:	89 e5                	mov    %esp,%ebp
80103257:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
8010325a:	c7 44 24 04 65 71 10 	movl   $0x80107165,0x4(%esp)
80103261:	80 
80103262:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103269:	e8 5a 09 00 00       	call   80103bc8 <initlock>
}
8010326e:	c9                   	leave  
8010326f:	c3                   	ret    

80103270 <mycpu>:
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	56                   	push   %esi
80103274:	53                   	push   %ebx
80103275:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103278:	9c                   	pushf  
80103279:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010327a:	f6 c4 02             	test   $0x2,%ah
8010327d:	75 58                	jne    801032d7 <mycpu+0x67>
  apicid = lapicid();
8010327f:	e8 dc f1 ff ff       	call   80102460 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103284:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010328a:	85 f6                	test   %esi,%esi
8010328c:	7e 3d                	jle    801032cb <mycpu+0x5b>
    if (cpus[i].apicid == apicid)
8010328e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103295:	39 c2                	cmp    %eax,%edx
80103297:	74 2e                	je     801032c7 <mycpu+0x57>
80103299:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010329e:	31 d2                	xor    %edx,%edx
801032a0:	42                   	inc    %edx
801032a1:	39 f2                	cmp    %esi,%edx
801032a3:	74 26                	je     801032cb <mycpu+0x5b>
    if (cpus[i].apicid == apicid)
801032a5:	0f b6 19             	movzbl (%ecx),%ebx
801032a8:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
801032ae:	39 c3                	cmp    %eax,%ebx
801032b0:	75 ee                	jne    801032a0 <mycpu+0x30>
      return &cpus[i];
801032b2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801032b5:	8d 04 42             	lea    (%edx,%eax,2),%eax
801032b8:	c1 e0 04             	shl    $0x4,%eax
801032bb:	05 80 27 11 80       	add    $0x80112780,%eax
}
801032c0:	83 c4 10             	add    $0x10,%esp
801032c3:	5b                   	pop    %ebx
801032c4:	5e                   	pop    %esi
801032c5:	5d                   	pop    %ebp
801032c6:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
801032c7:	31 d2                	xor    %edx,%edx
801032c9:	eb e7                	jmp    801032b2 <mycpu+0x42>
  panic("unknown apicid\n");
801032cb:	c7 04 24 6c 71 10 80 	movl   $0x8010716c,(%esp)
801032d2:	e8 39 d0 ff ff       	call   80100310 <panic>
    panic("mycpu called with interrupts enabled\n");
801032d7:	c7 04 24 48 72 10 80 	movl   $0x80107248,(%esp)
801032de:	e8 2d d0 ff ff       	call   80100310 <panic>
801032e3:	90                   	nop

801032e4 <cpuid>:
cpuid() {
801032e4:	55                   	push   %ebp
801032e5:	89 e5                	mov    %esp,%ebp
801032e7:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801032ea:	e8 81 ff ff ff       	call   80103270 <mycpu>
801032ef:	2d 80 27 11 80       	sub    $0x80112780,%eax
801032f4:	c1 f8 04             	sar    $0x4,%eax
801032f7:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
801032fa:	89 ca                	mov    %ecx,%edx
801032fc:	c1 e2 05             	shl    $0x5,%edx
801032ff:	29 ca                	sub    %ecx,%edx
80103301:	8d 14 90             	lea    (%eax,%edx,4),%edx
80103304:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
80103307:	89 ca                	mov    %ecx,%edx
80103309:	c1 e2 0f             	shl    $0xf,%edx
8010330c:	29 ca                	sub    %ecx,%edx
8010330e:	8d 04 90             	lea    (%eax,%edx,4),%eax
80103311:	f7 d8                	neg    %eax
}
80103313:	c9                   	leave  
80103314:	c3                   	ret    
80103315:	8d 76 00             	lea    0x0(%esi),%esi

80103318 <myproc>:
myproc(void) {
80103318:	55                   	push   %ebp
80103319:	89 e5                	mov    %esp,%ebp
8010331b:	53                   	push   %ebx
8010331c:	51                   	push   %ecx
  pushcli();
8010331d:	e8 36 09 00 00       	call   80103c58 <pushcli>
  c = mycpu();
80103322:	e8 49 ff ff ff       	call   80103270 <mycpu>
  p = c->proc;
80103327:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010332d:	e8 c2 09 00 00       	call   80103cf4 <popcli>
}
80103332:	89 d8                	mov    %ebx,%eax
80103334:	5b                   	pop    %ebx
80103335:	5b                   	pop    %ebx
80103336:	5d                   	pop    %ebp
80103337:	c3                   	ret    

80103338 <userinit>:
  for(s = s_cand; s < &s_cand[NPROC]; s++){
80103338:	b8 00 58 11 80       	mov    $0x80115800,%eax
8010333d:	8d 76 00             	lea    0x0(%esi),%esi
    s->valid = 0;
80103340:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    s->proc = 0;
80103347:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
  for(s = s_cand; s < &s_cand[NPROC]; s++){
8010334e:	83 c0 14             	add    $0x14,%eax
80103351:	3d 00 5d 11 80       	cmp    $0x80115d00,%eax
80103356:	72 e8                	jb     80103340 <userinit+0x8>
  s_cand[0].valid = 1;
80103358:	c7 05 0c 58 11 80 01 	movl   $0x1,0x8011580c
8010335f:	00 00 00 
80103362:	31 d2                	xor    %edx,%edx
    MLFQ_table[i].total = 0;
80103364:	c7 82 00 5d 11 80 00 	movl   $0x0,-0x7feea300(%edx)
8010336b:	00 00 00 
    MLFQ_table[i].recent = 0;
8010336e:	c7 82 04 5d 11 80 00 	movl   $0x0,-0x7feea2fc(%edx)
80103375:	00 00 00 
    for(j = 0; j < NPROC; j++){
80103378:	31 c0                	xor    %eax,%eax
8010337a:	66 90                	xchg   %ax,%ax
      MLFQ_table[i].wait[j] = 0;
8010337c:	c7 84 82 08 5d 11 80 	movl   $0x0,-0x7feea2f8(%edx,%eax,4)
80103383:	00 00 00 00 
    for(j = 0; j < NPROC; j++){
80103387:	40                   	inc    %eax
80103388:	83 f8 40             	cmp    $0x40,%eax
8010338b:	75 ef                	jne    8010337c <userinit+0x44>
8010338d:	81 c2 08 01 00 00    	add    $0x108,%edx
  for(i = 0; i < 3; i++){
80103393:	81 fa 18 03 00 00    	cmp    $0x318,%edx
80103399:	75 c9                	jne    80103364 <userinit+0x2c>
{
8010339b:	55                   	push   %ebp
8010339c:	89 e5                	mov    %esp,%ebp
8010339e:	53                   	push   %ebx
8010339f:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
801033a2:	e8 81 fd ff ff       	call   80103128 <allocproc>
801033a7:	89 c3                	mov    %eax,%ebx
  s_cand[0].proc = p;
801033a9:	a3 10 58 11 80       	mov    %eax,0x80115810
  initproc = p;
801033ae:	a3 a0 a5 10 80       	mov    %eax,0x8010a5a0
  if((p->pgdir = setupkvm()) == 0)
801033b3:	e8 38 2f 00 00       	call   801062f0 <setupkvm>
801033b8:	89 43 04             	mov    %eax,0x4(%ebx)
801033bb:	85 c0                	test   %eax,%eax
801033bd:	0f 84 cc 00 00 00    	je     8010348f <userinit+0x157>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801033c3:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
801033ca:	00 
801033cb:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
801033d2:	80 
801033d3:	89 04 24             	mov    %eax,(%esp)
801033d6:	e8 8d 2b 00 00       	call   80105f68 <inituvm>
  p->sz = PGSIZE;
801033db:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
801033e1:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801033e8:	00 
801033e9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801033f0:	00 
801033f1:	8b 43 18             	mov    0x18(%ebx),%eax
801033f4:	89 04 24             	mov    %eax,(%esp)
801033f7:	e8 98 09 00 00       	call   80103d94 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801033fc:	8b 43 18             	mov    0x18(%ebx),%eax
801033ff:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103405:	8b 43 18             	mov    0x18(%ebx),%eax
80103408:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010340e:	8b 43 18             	mov    0x18(%ebx),%eax
80103411:	8b 50 2c             	mov    0x2c(%eax),%edx
80103414:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103418:	8b 43 18             	mov    0x18(%ebx),%eax
8010341b:	8b 50 2c             	mov    0x2c(%eax),%edx
8010341e:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103422:	8b 43 18             	mov    0x18(%ebx),%eax
80103425:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
8010342c:	8b 43 18             	mov    0x18(%ebx),%eax
8010342f:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103436:	8b 43 18             	mov    0x18(%ebx),%eax
80103439:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103440:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103447:	00 
80103448:	c7 44 24 04 95 71 10 	movl   $0x80107195,0x4(%esp)
8010344f:	80 
80103450:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103453:	89 04 24             	mov    %eax,(%esp)
80103456:	e8 d1 0a 00 00       	call   80103f2c <safestrcpy>
  p->cwd = namei("/");
8010345b:	c7 04 24 9e 71 10 80 	movl   $0x8010719e,(%esp)
80103462:	e8 c1 e8 ff ff       	call   80101d28 <namei>
80103467:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
8010346a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103471:	e8 1a 08 00 00       	call   80103c90 <acquire>
  p->state = RUNNABLE;
80103476:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
8010347d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103484:	e8 c3 08 00 00       	call   80103d4c <release>
}
80103489:	83 c4 14             	add    $0x14,%esp
8010348c:	5b                   	pop    %ebx
8010348d:	5d                   	pop    %ebp
8010348e:	c3                   	ret    
    panic("userinit: out of memory?");
8010348f:	c7 04 24 7c 71 10 80 	movl   $0x8010717c,(%esp)
80103496:	e8 75 ce ff ff       	call   80100310 <panic>
8010349b:	90                   	nop

8010349c <growproc>:
{
8010349c:	55                   	push   %ebp
8010349d:	89 e5                	mov    %esp,%ebp
8010349f:	53                   	push   %ebx
801034a0:	83 ec 14             	sub    $0x14,%esp
  struct proc *curproc = myproc();
801034a3:	e8 70 fe ff ff       	call   80103318 <myproc>
801034a8:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
801034aa:	8b 00                	mov    (%eax),%eax
  if(n > 0){
801034ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801034b0:	7e 2e                	jle    801034e0 <growproc+0x44>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801034b2:	8b 55 08             	mov    0x8(%ebp),%edx
801034b5:	01 c2                	add    %eax,%edx
801034b7:	89 54 24 08          	mov    %edx,0x8(%esp)
801034bb:	89 44 24 04          	mov    %eax,0x4(%esp)
801034bf:	8b 43 04             	mov    0x4(%ebx),%eax
801034c2:	89 04 24             	mov    %eax,(%esp)
801034c5:	e8 82 2c 00 00       	call   8010614c <allocuvm>
801034ca:	85 c0                	test   %eax,%eax
801034cc:	74 32                	je     80103500 <growproc+0x64>
  curproc->sz = sz;
801034ce:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801034d0:	89 1c 24             	mov    %ebx,(%esp)
801034d3:	e8 94 29 00 00       	call   80105e6c <switchuvm>
  return 0;
801034d8:	31 c0                	xor    %eax,%eax
}
801034da:	83 c4 14             	add    $0x14,%esp
801034dd:	5b                   	pop    %ebx
801034de:	5d                   	pop    %ebp
801034df:	c3                   	ret    
  } else if(n < 0){
801034e0:	74 ec                	je     801034ce <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801034e2:	8b 55 08             	mov    0x8(%ebp),%edx
801034e5:	01 c2                	add    %eax,%edx
801034e7:	89 54 24 08          	mov    %edx,0x8(%esp)
801034eb:	89 44 24 04          	mov    %eax,0x4(%esp)
801034ef:	8b 43 04             	mov    0x4(%ebx),%eax
801034f2:	89 04 24             	mov    %eax,(%esp)
801034f5:	e8 aa 2b 00 00       	call   801060a4 <deallocuvm>
801034fa:	85 c0                	test   %eax,%eax
801034fc:	75 d0                	jne    801034ce <growproc+0x32>
801034fe:	66 90                	xchg   %ax,%ax
      return -1;
80103500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103505:	eb d3                	jmp    801034da <growproc+0x3e>
80103507:	90                   	nop

80103508 <fork>:
{
80103508:	55                   	push   %ebp
80103509:	89 e5                	mov    %esp,%ebp
8010350b:	57                   	push   %edi
8010350c:	56                   	push   %esi
8010350d:	53                   	push   %ebx
8010350e:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *curproc = myproc();
80103511:	e8 02 fe ff ff       	call   80103318 <myproc>
80103516:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103518:	e8 0b fc ff ff       	call   80103128 <allocproc>
8010351d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103520:	85 c0                	test   %eax,%eax
80103522:	0f 84 c4 00 00 00    	je     801035ec <fork+0xe4>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103528:	8b 03                	mov    (%ebx),%eax
8010352a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010352e:	8b 43 04             	mov    0x4(%ebx),%eax
80103531:	89 04 24             	mov    %eax,(%esp)
80103534:	e8 73 2e 00 00       	call   801063ac <copyuvm>
80103539:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010353c:	89 42 04             	mov    %eax,0x4(%edx)
8010353f:	85 c0                	test   %eax,%eax
80103541:	0f 84 ac 00 00 00    	je     801035f3 <fork+0xeb>
  np->sz = curproc->sz;
80103547:	8b 03                	mov    (%ebx),%eax
80103549:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010354c:	89 02                	mov    %eax,(%edx)
  np->parent = curproc;
8010354e:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103551:	8b 42 18             	mov    0x18(%edx),%eax
80103554:	89 45 e0             	mov    %eax,-0x20(%ebp)
80103557:	8b 73 18             	mov    0x18(%ebx),%esi
8010355a:	b9 13 00 00 00       	mov    $0x13,%ecx
8010355f:	89 c7                	mov    %eax,%edi
80103561:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
80103563:	8b 42 18             	mov    0x18(%edx),%eax
80103566:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
8010356d:	31 f6                	xor    %esi,%esi
8010356f:	90                   	nop
    if(curproc->ofile[i])
80103570:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103574:	85 c0                	test   %eax,%eax
80103576:	74 0f                	je     80103587 <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103578:	89 04 24             	mov    %eax,(%esp)
8010357b:	e8 7c d7 ff ff       	call   80100cfc <filedup>
80103580:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103583:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103587:	46                   	inc    %esi
80103588:	83 fe 10             	cmp    $0x10,%esi
8010358b:	75 e3                	jne    80103570 <fork+0x68>
  np->cwd = idup(curproc->cwd);
8010358d:	8b 43 68             	mov    0x68(%ebx),%eax
80103590:	89 04 24             	mov    %eax,(%esp)
80103593:	e8 88 df ff ff       	call   80101520 <idup>
80103598:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010359b:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
8010359e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801035a5:	00 
801035a6:	83 c3 6c             	add    $0x6c,%ebx
801035a9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801035ad:	89 d0                	mov    %edx,%eax
801035af:	83 c0 6c             	add    $0x6c,%eax
801035b2:	89 04 24             	mov    %eax,(%esp)
801035b5:	e8 72 09 00 00       	call   80103f2c <safestrcpy>
  pid = np->pid;
801035ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035bd:	8b 58 10             	mov    0x10(%eax),%ebx
  acquire(&ptable.lock);
801035c0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035c7:	e8 c4 06 00 00       	call   80103c90 <acquire>
  np->state = RUNNABLE;
801035cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035cf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
801035d6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035dd:	e8 6a 07 00 00       	call   80103d4c <release>
}
801035e2:	89 d8                	mov    %ebx,%eax
801035e4:	83 c4 2c             	add    $0x2c,%esp
801035e7:	5b                   	pop    %ebx
801035e8:	5e                   	pop    %esi
801035e9:	5f                   	pop    %edi
801035ea:	5d                   	pop    %ebp
801035eb:	c3                   	ret    
    return -1;
801035ec:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801035f1:	eb ef                	jmp    801035e2 <fork+0xda>
    kfree(np->kstack);
801035f3:	8b 42 08             	mov    0x8(%edx),%eax
801035f6:	89 04 24             	mov    %eax,(%esp)
801035f9:	e8 b2 ea ff ff       	call   801020b0 <kfree>
    np->kstack = 0;
801035fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103601:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
80103608:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
8010360f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103614:	eb cc                	jmp    801035e2 <fork+0xda>
80103616:	66 90                	xchg   %ax,%ax

80103618 <sched>:
{
80103618:	55                   	push   %ebp
80103619:	89 e5                	mov    %esp,%ebp
8010361b:	56                   	push   %esi
8010361c:	53                   	push   %ebx
8010361d:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
80103620:	e8 f3 fc ff ff       	call   80103318 <myproc>
80103625:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103627:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010362e:	e8 fd 05 00 00       	call   80103c30 <holding>
80103633:	85 c0                	test   %eax,%eax
80103635:	74 4f                	je     80103686 <sched+0x6e>
  if(mycpu()->ncli != 1)
80103637:	e8 34 fc ff ff       	call   80103270 <mycpu>
8010363c:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103643:	75 65                	jne    801036aa <sched+0x92>
  if(p->state == RUNNING)
80103645:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103649:	74 53                	je     8010369e <sched+0x86>
8010364b:	9c                   	pushf  
8010364c:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010364d:	f6 c4 02             	test   $0x2,%ah
80103650:	75 40                	jne    80103692 <sched+0x7a>
  intena = mycpu()->intena;
80103652:	e8 19 fc ff ff       	call   80103270 <mycpu>
80103657:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
8010365d:	e8 0e fc ff ff       	call   80103270 <mycpu>
80103662:	8b 40 04             	mov    0x4(%eax),%eax
80103665:	89 44 24 04          	mov    %eax,0x4(%esp)
80103669:	83 c3 1c             	add    $0x1c,%ebx
8010366c:	89 1c 24             	mov    %ebx,(%esp)
8010366f:	e8 01 09 00 00       	call   80103f75 <swtch>
  mycpu()->intena = intena;
80103674:	e8 f7 fb ff ff       	call   80103270 <mycpu>
80103679:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
8010367f:	83 c4 10             	add    $0x10,%esp
80103682:	5b                   	pop    %ebx
80103683:	5e                   	pop    %esi
80103684:	5d                   	pop    %ebp
80103685:	c3                   	ret    
    panic("sched ptable.lock");
80103686:	c7 04 24 a0 71 10 80 	movl   $0x801071a0,(%esp)
8010368d:	e8 7e cc ff ff       	call   80100310 <panic>
    panic("sched interruptible");
80103692:	c7 04 24 cc 71 10 80 	movl   $0x801071cc,(%esp)
80103699:	e8 72 cc ff ff       	call   80100310 <panic>
    panic("sched running");
8010369e:	c7 04 24 be 71 10 80 	movl   $0x801071be,(%esp)
801036a5:	e8 66 cc ff ff       	call   80100310 <panic>
    panic("sched locks");
801036aa:	c7 04 24 b2 71 10 80 	movl   $0x801071b2,(%esp)
801036b1:	e8 5a cc ff ff       	call   80100310 <panic>
801036b6:	66 90                	xchg   %ax,%ax

801036b8 <exit>:
{
801036b8:	55                   	push   %ebp
801036b9:	89 e5                	mov    %esp,%ebp
801036bb:	56                   	push   %esi
801036bc:	53                   	push   %ebx
801036bd:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
801036c0:	e8 53 fc ff ff       	call   80103318 <myproc>
801036c5:	89 c6                	mov    %eax,%esi
  if(curproc == initproc)
801036c7:	31 db                	xor    %ebx,%ebx
801036c9:	3b 05 a0 a5 10 80    	cmp    0x8010a5a0,%eax
801036cf:	0f 84 dd 00 00 00    	je     801037b2 <exit+0xfa>
801036d5:	8d 76 00             	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
801036d8:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
801036dc:	85 c0                	test   %eax,%eax
801036de:	74 10                	je     801036f0 <exit+0x38>
      fileclose(curproc->ofile[fd]);
801036e0:	89 04 24             	mov    %eax,(%esp)
801036e3:	e8 58 d6 ff ff       	call   80100d40 <fileclose>
      curproc->ofile[fd] = 0;
801036e8:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
801036ef:	00 
  for(fd = 0; fd < NOFILE; fd++){
801036f0:	43                   	inc    %ebx
801036f1:	83 fb 10             	cmp    $0x10,%ebx
801036f4:	75 e2                	jne    801036d8 <exit+0x20>
  begin_op();
801036f6:	e8 9d f0 ff ff       	call   80102798 <begin_op>
  iput(curproc->cwd);
801036fb:	8b 46 68             	mov    0x68(%esi),%eax
801036fe:	89 04 24             	mov    %eax,(%esp)
80103701:	e8 5a df ff ff       	call   80101660 <iput>
  end_op();
80103706:	e8 e9 f0 ff ff       	call   801027f4 <end_op>
  curproc->cwd = 0;
8010370b:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
80103712:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103719:	e8 72 05 00 00       	call   80103c90 <acquire>
  wakeup1(curproc->parent);
8010371e:	8b 46 14             	mov    0x14(%esi),%eax
80103721:	e8 7a f9 ff ff       	call   801030a0 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103726:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
8010372b:	eb 11                	jmp    8010373e <exit+0x86>
8010372d:	8d 76 00             	lea    0x0(%esi),%esi
80103730:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103736:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
8010373c:	74 26                	je     80103764 <exit+0xac>
    if(p->parent == curproc){
8010373e:	39 73 14             	cmp    %esi,0x14(%ebx)
80103741:	75 ed                	jne    80103730 <exit+0x78>
      p->parent = initproc;
80103743:	a1 a0 a5 10 80       	mov    0x8010a5a0,%eax
80103748:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
8010374b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010374f:	75 df                	jne    80103730 <exit+0x78>
        wakeup1(initproc);
80103751:	e8 4a f9 ff ff       	call   801030a0 <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103756:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010375c:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103762:	75 da                	jne    8010373e <exit+0x86>
  if(curproc->myst == s_cand){
80103764:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
8010376a:	3d 00 58 11 80       	cmp    $0x80115800,%eax
8010376f:	74 4d                	je     801037be <exit+0x106>
    curproc->myst->valid = 0;
80103771:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    s_cand[0].share += curproc->myst->share;
80103778:	8b 86 84 00 00 00    	mov    0x84(%esi),%eax
8010377e:	8b 0d 08 58 11 80    	mov    0x80115808,%ecx
80103784:	03 48 08             	add    0x8(%eax),%ecx
80103787:	89 0d 08 58 11 80    	mov    %ecx,0x80115808
    s_cand[0].stride = 10000000 / s_cand[0].share;
8010378d:	b8 80 96 98 00       	mov    $0x989680,%eax
80103792:	99                   	cltd   
80103793:	f7 f9                	idiv   %ecx
80103795:	a3 00 58 11 80       	mov    %eax,0x80115800
  curproc->state = ZOMBIE;
8010379a:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801037a1:	e8 72 fe ff ff       	call   80103618 <sched>
  panic("zombie exit");
801037a6:	c7 04 24 ed 71 10 80 	movl   $0x801071ed,(%esp)
801037ad:	e8 5e cb ff ff       	call   80100310 <panic>
    panic("init exiting");
801037b2:	c7 04 24 e0 71 10 80 	movl   $0x801071e0,(%esp)
801037b9:	e8 52 cb ff ff       	call   80100310 <panic>
    pop_MLFQ(curproc);
801037be:	89 34 24             	mov    %esi,(%esp)
801037c1:	e8 52 2e 00 00       	call   80106618 <pop_MLFQ>
801037c6:	eb d2                	jmp    8010379a <exit+0xe2>

801037c8 <yield>:
{
801037c8:	55                   	push   %ebp
801037c9:	89 e5                	mov    %esp,%ebp
801037cb:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801037ce:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037d5:	e8 b6 04 00 00       	call   80103c90 <acquire>
  myproc()->state = RUNNABLE;
801037da:	e8 39 fb ff ff       	call   80103318 <myproc>
801037df:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
801037e6:	e8 2d fe ff ff       	call   80103618 <sched>
  release(&ptable.lock);
801037eb:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037f2:	e8 55 05 00 00       	call   80103d4c <release>
}
801037f7:	c9                   	leave  
801037f8:	c3                   	ret    
801037f9:	8d 76 00             	lea    0x0(%esi),%esi

801037fc <sleep>:
{
801037fc:	55                   	push   %ebp
801037fd:	89 e5                	mov    %esp,%ebp
801037ff:	57                   	push   %edi
80103800:	56                   	push   %esi
80103801:	53                   	push   %ebx
80103802:	83 ec 1c             	sub    $0x1c,%esp
80103805:	8b 7d 08             	mov    0x8(%ebp),%edi
80103808:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
8010380b:	e8 08 fb ff ff       	call   80103318 <myproc>
80103810:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103812:	85 c0                	test   %eax,%eax
80103814:	74 7c                	je     80103892 <sleep+0x96>
  if(lk == 0)
80103816:	85 f6                	test   %esi,%esi
80103818:	74 6c                	je     80103886 <sleep+0x8a>
  if(lk != &ptable.lock){  //DOC: sleeplock0
8010381a:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103820:	74 46                	je     80103868 <sleep+0x6c>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103822:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103829:	e8 62 04 00 00       	call   80103c90 <acquire>
    release(lk);
8010382e:	89 34 24             	mov    %esi,(%esp)
80103831:	e8 16 05 00 00       	call   80103d4c <release>
  p->chan = chan;
80103836:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103839:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103840:	e8 d3 fd ff ff       	call   80103618 <sched>
  p->chan = 0;
80103845:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
8010384c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103853:	e8 f4 04 00 00       	call   80103d4c <release>
    acquire(lk);
80103858:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010385b:	83 c4 1c             	add    $0x1c,%esp
8010385e:	5b                   	pop    %ebx
8010385f:	5e                   	pop    %esi
80103860:	5f                   	pop    %edi
80103861:	5d                   	pop    %ebp
    acquire(lk);
80103862:	e9 29 04 00 00       	jmp    80103c90 <acquire>
80103867:	90                   	nop
  p->chan = chan;
80103868:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
8010386b:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103872:	e8 a1 fd ff ff       	call   80103618 <sched>
  p->chan = 0;
80103877:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010387e:	83 c4 1c             	add    $0x1c,%esp
80103881:	5b                   	pop    %ebx
80103882:	5e                   	pop    %esi
80103883:	5f                   	pop    %edi
80103884:	5d                   	pop    %ebp
80103885:	c3                   	ret    
    panic("sleep without lk");
80103886:	c7 04 24 ff 71 10 80 	movl   $0x801071ff,(%esp)
8010388d:	e8 7e ca ff ff       	call   80100310 <panic>
    panic("sleep");
80103892:	c7 04 24 f9 71 10 80 	movl   $0x801071f9,(%esp)
80103899:	e8 72 ca ff ff       	call   80100310 <panic>
8010389e:	66 90                	xchg   %ax,%ax

801038a0 <wait>:
{
801038a0:	55                   	push   %ebp
801038a1:	89 e5                	mov    %esp,%ebp
801038a3:	56                   	push   %esi
801038a4:	53                   	push   %ebx
801038a5:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
801038a8:	e8 6b fa ff ff       	call   80103318 <myproc>
801038ad:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
801038af:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801038b6:	e8 d5 03 00 00       	call   80103c90 <acquire>
    havekids = 0;
801038bb:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038bd:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801038c2:	eb 0e                	jmp    801038d2 <wait+0x32>
801038c4:	81 c3 88 00 00 00    	add    $0x88,%ebx
801038ca:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
801038d0:	74 1e                	je     801038f0 <wait+0x50>
      if(p->parent != curproc)
801038d2:	39 73 14             	cmp    %esi,0x14(%ebx)
801038d5:	75 ed                	jne    801038c4 <wait+0x24>
      if(p->state == ZOMBIE){
801038d7:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801038db:	74 30                	je     8010390d <wait+0x6d>
      havekids = 1;
801038dd:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038e2:	81 c3 88 00 00 00    	add    $0x88,%ebx
801038e8:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
801038ee:	75 e2                	jne    801038d2 <wait+0x32>
    if(!havekids || curproc->killed){
801038f0:	85 c0                	test   %eax,%eax
801038f2:	74 6e                	je     80103962 <wait+0xc2>
801038f4:	8b 46 24             	mov    0x24(%esi),%eax
801038f7:	85 c0                	test   %eax,%eax
801038f9:	75 67                	jne    80103962 <wait+0xc2>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801038fb:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103902:	80 
80103903:	89 34 24             	mov    %esi,(%esp)
80103906:	e8 f1 fe ff ff       	call   801037fc <sleep>
  }
8010390b:	eb ae                	jmp    801038bb <wait+0x1b>
        pid = p->pid;
8010390d:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103910:	8b 43 08             	mov    0x8(%ebx),%eax
80103913:	89 04 24             	mov    %eax,(%esp)
80103916:	e8 95 e7 ff ff       	call   801020b0 <kfree>
        p->kstack = 0;
8010391b:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103922:	8b 43 04             	mov    0x4(%ebx),%eax
80103925:	89 04 24             	mov    %eax,(%esp)
80103928:	e8 4f 29 00 00       	call   8010627c <freevm>
        p->pid = 0;
8010392d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103934:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010393b:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
8010393f:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103946:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010394d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103954:	e8 f3 03 00 00       	call   80103d4c <release>
}
80103959:	89 f0                	mov    %esi,%eax
8010395b:	83 c4 10             	add    $0x10,%esp
8010395e:	5b                   	pop    %ebx
8010395f:	5e                   	pop    %esi
80103960:	5d                   	pop    %ebp
80103961:	c3                   	ret    
      release(&ptable.lock);
80103962:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103969:	e8 de 03 00 00       	call   80103d4c <release>
      return -1;
8010396e:	be ff ff ff ff       	mov    $0xffffffff,%esi
}
80103973:	89 f0                	mov    %esi,%eax
80103975:	83 c4 10             	add    $0x10,%esp
80103978:	5b                   	pop    %ebx
80103979:	5e                   	pop    %esi
8010397a:	5d                   	pop    %ebp
8010397b:	c3                   	ret    

8010397c <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010397c:	55                   	push   %ebp
8010397d:	89 e5                	mov    %esp,%ebp
8010397f:	53                   	push   %ebx
80103980:	83 ec 14             	sub    $0x14,%esp
80103983:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103986:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010398d:	e8 fe 02 00 00       	call   80103c90 <acquire>
  wakeup1(chan);
80103992:	89 d8                	mov    %ebx,%eax
80103994:	e8 07 f7 ff ff       	call   801030a0 <wakeup1>
  release(&ptable.lock);
80103999:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
801039a0:	83 c4 14             	add    $0x14,%esp
801039a3:	5b                   	pop    %ebx
801039a4:	5d                   	pop    %ebp
  release(&ptable.lock);
801039a5:	e9 a2 03 00 00       	jmp    80103d4c <release>
801039aa:	66 90                	xchg   %ax,%ax

801039ac <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801039ac:	55                   	push   %ebp
801039ad:	89 e5                	mov    %esp,%ebp
801039af:	53                   	push   %ebx
801039b0:	83 ec 14             	sub    $0x14,%esp
801039b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801039b6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039bd:	e8 ce 02 00 00       	call   80103c90 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039c2:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801039c7:	eb 0f                	jmp    801039d8 <kill+0x2c>
801039c9:	8d 76 00             	lea    0x0(%esi),%esi
801039cc:	05 88 00 00 00       	add    $0x88,%eax
801039d1:	3d 54 4f 11 80       	cmp    $0x80114f54,%eax
801039d6:	74 34                	je     80103a0c <kill+0x60>
    if(p->pid == pid){
801039d8:	39 58 10             	cmp    %ebx,0x10(%eax)
801039db:	75 ef                	jne    801039cc <kill+0x20>
      p->killed = 1;
801039dd:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801039e4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801039e8:	74 16                	je     80103a00 <kill+0x54>
        p->state = RUNNABLE;
      release(&ptable.lock);
801039ea:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039f1:	e8 56 03 00 00       	call   80103d4c <release>
      return 0;
801039f6:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
801039f8:	83 c4 14             	add    $0x14,%esp
801039fb:	5b                   	pop    %ebx
801039fc:	5d                   	pop    %ebp
801039fd:	c3                   	ret    
801039fe:	66 90                	xchg   %ax,%ax
        p->state = RUNNABLE;
80103a00:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103a07:	eb e1                	jmp    801039ea <kill+0x3e>
80103a09:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103a0c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a13:	e8 34 03 00 00       	call   80103d4c <release>
  return -1;
80103a18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103a1d:	83 c4 14             	add    $0x14,%esp
80103a20:	5b                   	pop    %ebx
80103a21:	5d                   	pop    %ebp
80103a22:	c3                   	ret    
80103a23:	90                   	nop

80103a24 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103a24:	55                   	push   %ebp
80103a25:	89 e5                	mov    %esp,%ebp
80103a27:	57                   	push   %edi
80103a28:	56                   	push   %esi
80103a29:	53                   	push   %ebx
80103a2a:	83 ec 4c             	sub    $0x4c,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a2d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
procdump(void)
80103a32:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103a35:	eb 4a                	jmp    80103a81 <procdump+0x5d>
80103a37:	90                   	nop
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103a38:	8b 04 85 70 72 10 80 	mov    -0x7fef8d90(,%eax,4),%eax
80103a3f:	85 c0                	test   %eax,%eax
80103a41:	74 4a                	je     80103a8d <procdump+0x69>
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
80103a43:	8d 53 6c             	lea    0x6c(%ebx),%edx
80103a46:	89 54 24 0c          	mov    %edx,0xc(%esp)
80103a4a:	89 44 24 08          	mov    %eax,0x8(%esp)
80103a4e:	8b 43 10             	mov    0x10(%ebx),%eax
80103a51:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a55:	c7 04 24 14 72 10 80 	movl   $0x80107214,(%esp)
80103a5c:	e8 53 cb ff ff       	call   801005b4 <cprintf>
    
    if(p->state == SLEEPING){
80103a61:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103a65:	74 2d                	je     80103a94 <procdump+0x70>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103a67:	c7 04 24 8b 75 10 80 	movl   $0x8010758b,(%esp)
80103a6e:	e8 41 cb ff ff       	call   801005b4 <cprintf>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a73:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103a79:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80103a7f:	74 4f                	je     80103ad0 <procdump+0xac>
    if(p->state == UNUSED)
80103a81:	8b 43 0c             	mov    0xc(%ebx),%eax
80103a84:	85 c0                	test   %eax,%eax
80103a86:	74 eb                	je     80103a73 <procdump+0x4f>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103a88:	83 f8 05             	cmp    $0x5,%eax
80103a8b:	76 ab                	jbe    80103a38 <procdump+0x14>
      state = "???";
80103a8d:	b8 10 72 10 80       	mov    $0x80107210,%eax
80103a92:	eb af                	jmp    80103a43 <procdump+0x1f>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103a94:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103a97:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a9b:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a9e:	8b 40 0c             	mov    0xc(%eax),%eax
80103aa1:	83 c0 08             	add    $0x8,%eax
80103aa4:	89 04 24             	mov    %eax,(%esp)
80103aa7:	e8 38 01 00 00       	call   80103be4 <getcallerpcs>
80103aac:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103aaf:	90                   	nop
      for(i=0; i<10 && pc[i] != 0; i++)
80103ab0:	8b 17                	mov    (%edi),%edx
80103ab2:	85 d2                	test   %edx,%edx
80103ab4:	74 b1                	je     80103a67 <procdump+0x43>
        cprintf(" %p", pc[i]);
80103ab6:	89 54 24 04          	mov    %edx,0x4(%esp)
80103aba:	c7 04 24 61 6c 10 80 	movl   $0x80106c61,(%esp)
80103ac1:	e8 ee ca ff ff       	call   801005b4 <cprintf>
80103ac6:	83 c7 04             	add    $0x4,%edi
      for(i=0; i<10 && pc[i] != 0; i++)
80103ac9:	39 f7                	cmp    %esi,%edi
80103acb:	75 e3                	jne    80103ab0 <procdump+0x8c>
80103acd:	eb 98                	jmp    80103a67 <procdump+0x43>
80103acf:	90                   	nop
  }
}
80103ad0:	83 c4 4c             	add    $0x4c,%esp
80103ad3:	5b                   	pop    %ebx
80103ad4:	5e                   	pop    %esi
80103ad5:	5f                   	pop    %edi
80103ad6:	5d                   	pop    %ebp
80103ad7:	c3                   	ret    

80103ad8 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103ad8:	55                   	push   %ebp
80103ad9:	89 e5                	mov    %esp,%ebp
80103adb:	53                   	push   %ebx
80103adc:	83 ec 14             	sub    $0x14,%esp
80103adf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103ae2:	c7 44 24 04 88 72 10 	movl   $0x80107288,0x4(%esp)
80103ae9:	80 
80103aea:	8d 43 04             	lea    0x4(%ebx),%eax
80103aed:	89 04 24             	mov    %eax,(%esp)
80103af0:	e8 d3 00 00 00       	call   80103bc8 <initlock>
  lk->name = name;
80103af5:	8b 45 0c             	mov    0xc(%ebp),%eax
80103af8:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103afb:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103b01:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103b08:	83 c4 14             	add    $0x14,%esp
80103b0b:	5b                   	pop    %ebx
80103b0c:	5d                   	pop    %ebp
80103b0d:	c3                   	ret    
80103b0e:	66 90                	xchg   %ax,%ax

80103b10 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	56                   	push   %esi
80103b14:	53                   	push   %ebx
80103b15:	83 ec 10             	sub    $0x10,%esp
80103b18:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103b1b:	8d 73 04             	lea    0x4(%ebx),%esi
80103b1e:	89 34 24             	mov    %esi,(%esp)
80103b21:	e8 6a 01 00 00       	call   80103c90 <acquire>
  while (lk->locked) {
80103b26:	8b 13                	mov    (%ebx),%edx
80103b28:	85 d2                	test   %edx,%edx
80103b2a:	74 12                	je     80103b3e <acquiresleep+0x2e>
    sleep(lk, &lk->lk);
80103b2c:	89 74 24 04          	mov    %esi,0x4(%esp)
80103b30:	89 1c 24             	mov    %ebx,(%esp)
80103b33:	e8 c4 fc ff ff       	call   801037fc <sleep>
  while (lk->locked) {
80103b38:	8b 03                	mov    (%ebx),%eax
80103b3a:	85 c0                	test   %eax,%eax
80103b3c:	75 ee                	jne    80103b2c <acquiresleep+0x1c>
  }
  lk->locked = 1;
80103b3e:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103b44:	e8 cf f7 ff ff       	call   80103318 <myproc>
80103b49:	8b 40 10             	mov    0x10(%eax),%eax
80103b4c:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103b4f:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103b52:	83 c4 10             	add    $0x10,%esp
80103b55:	5b                   	pop    %ebx
80103b56:	5e                   	pop    %esi
80103b57:	5d                   	pop    %ebp
  release(&lk->lk);
80103b58:	e9 ef 01 00 00       	jmp    80103d4c <release>
80103b5d:	8d 76 00             	lea    0x0(%esi),%esi

80103b60 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103b60:	55                   	push   %ebp
80103b61:	89 e5                	mov    %esp,%ebp
80103b63:	56                   	push   %esi
80103b64:	53                   	push   %ebx
80103b65:	83 ec 10             	sub    $0x10,%esp
80103b68:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103b6b:	8d 73 04             	lea    0x4(%ebx),%esi
80103b6e:	89 34 24             	mov    %esi,(%esp)
80103b71:	e8 1a 01 00 00       	call   80103c90 <acquire>
  lk->locked = 0;
80103b76:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103b7c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103b83:	89 1c 24             	mov    %ebx,(%esp)
80103b86:	e8 f1 fd ff ff       	call   8010397c <wakeup>
  release(&lk->lk);
80103b8b:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103b8e:	83 c4 10             	add    $0x10,%esp
80103b91:	5b                   	pop    %ebx
80103b92:	5e                   	pop    %esi
80103b93:	5d                   	pop    %ebp
  release(&lk->lk);
80103b94:	e9 b3 01 00 00       	jmp    80103d4c <release>
80103b99:	8d 76 00             	lea    0x0(%esi),%esi

80103b9c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103b9c:	55                   	push   %ebp
80103b9d:	89 e5                	mov    %esp,%ebp
80103b9f:	56                   	push   %esi
80103ba0:	53                   	push   %ebx
80103ba1:	83 ec 10             	sub    $0x10,%esp
80103ba4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103ba7:	8d 73 04             	lea    0x4(%ebx),%esi
80103baa:	89 34 24             	mov    %esi,(%esp)
80103bad:	e8 de 00 00 00       	call   80103c90 <acquire>
  r = lk->locked;
80103bb2:	8b 1b                	mov    (%ebx),%ebx
  release(&lk->lk);
80103bb4:	89 34 24             	mov    %esi,(%esp)
80103bb7:	e8 90 01 00 00       	call   80103d4c <release>
  return r;
}
80103bbc:	89 d8                	mov    %ebx,%eax
80103bbe:	83 c4 10             	add    $0x10,%esp
80103bc1:	5b                   	pop    %ebx
80103bc2:	5e                   	pop    %esi
80103bc3:	5d                   	pop    %ebp
80103bc4:	c3                   	ret    
80103bc5:	66 90                	xchg   %ax,%ax
80103bc7:	90                   	nop

80103bc8 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103bc8:	55                   	push   %ebp
80103bc9:	89 e5                	mov    %esp,%ebp
80103bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103bce:	8b 55 0c             	mov    0xc(%ebp),%edx
80103bd1:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103bd4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103bda:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103be1:	5d                   	pop    %ebp
80103be2:	c3                   	ret    
80103be3:	90                   	nop

80103be4 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103be4:	55                   	push   %ebp
80103be5:	89 e5                	mov    %esp,%ebp
80103be7:	53                   	push   %ebx
80103be8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103beb:	8b 55 08             	mov    0x8(%ebp),%edx
80103bee:	83 ea 08             	sub    $0x8,%edx
  for(i = 0; i < 10; i++){
80103bf1:	31 c0                	xor    %eax,%eax
80103bf3:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103bf4:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103bfa:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103c00:	77 12                	ja     80103c14 <getcallerpcs+0x30>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103c02:	8b 5a 04             	mov    0x4(%edx),%ebx
80103c05:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103c08:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103c0a:	40                   	inc    %eax
80103c0b:	83 f8 0a             	cmp    $0xa,%eax
80103c0e:	75 e4                	jne    80103bf4 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80103c10:	5b                   	pop    %ebx
80103c11:	5d                   	pop    %ebp
80103c12:	c3                   	ret    
80103c13:	90                   	nop
    pcs[i] = 0;
80103c14:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103c1b:	40                   	inc    %eax
80103c1c:	83 f8 0a             	cmp    $0xa,%eax
80103c1f:	74 ef                	je     80103c10 <getcallerpcs+0x2c>
    pcs[i] = 0;
80103c21:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103c28:	40                   	inc    %eax
80103c29:	83 f8 0a             	cmp    $0xa,%eax
80103c2c:	75 e6                	jne    80103c14 <getcallerpcs+0x30>
80103c2e:	eb e0                	jmp    80103c10 <getcallerpcs+0x2c>

80103c30 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	53                   	push   %ebx
80103c34:	51                   	push   %ecx
80103c35:	8b 45 08             	mov    0x8(%ebp),%eax
  return lock->locked && lock->cpu == mycpu();
80103c38:	8b 18                	mov    (%eax),%ebx
80103c3a:	85 db                	test   %ebx,%ebx
80103c3c:	75 06                	jne    80103c44 <holding+0x14>
80103c3e:	31 c0                	xor    %eax,%eax
}
80103c40:	5a                   	pop    %edx
80103c41:	5b                   	pop    %ebx
80103c42:	5d                   	pop    %ebp
80103c43:	c3                   	ret    
  return lock->locked && lock->cpu == mycpu();
80103c44:	8b 58 08             	mov    0x8(%eax),%ebx
80103c47:	e8 24 f6 ff ff       	call   80103270 <mycpu>
80103c4c:	39 c3                	cmp    %eax,%ebx
80103c4e:	0f 94 c0             	sete   %al
80103c51:	0f b6 c0             	movzbl %al,%eax
}
80103c54:	5a                   	pop    %edx
80103c55:	5b                   	pop    %ebx
80103c56:	5d                   	pop    %ebp
80103c57:	c3                   	ret    

80103c58 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103c58:	55                   	push   %ebp
80103c59:	89 e5                	mov    %esp,%ebp
80103c5b:	53                   	push   %ebx
80103c5c:	50                   	push   %eax
80103c5d:	9c                   	pushf  
80103c5e:	5b                   	pop    %ebx
  asm volatile("cli");
80103c5f:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103c60:	e8 0b f6 ff ff       	call   80103270 <mycpu>
80103c65:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80103c6b:	85 c0                	test   %eax,%eax
80103c6d:	75 11                	jne    80103c80 <pushcli+0x28>
    mycpu()->intena = eflags & FL_IF;
80103c6f:	e8 fc f5 ff ff       	call   80103270 <mycpu>
80103c74:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103c7a:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
80103c80:	e8 eb f5 ff ff       	call   80103270 <mycpu>
80103c85:	ff 80 a4 00 00 00    	incl   0xa4(%eax)
}
80103c8b:	58                   	pop    %eax
80103c8c:	5b                   	pop    %ebx
80103c8d:	5d                   	pop    %ebp
80103c8e:	c3                   	ret    
80103c8f:	90                   	nop

80103c90 <acquire>:
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	53                   	push   %ebx
80103c94:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103c97:	e8 bc ff ff ff       	call   80103c58 <pushcli>
  if(holding(lk))
80103c9c:	8b 45 08             	mov    0x8(%ebp),%eax
80103c9f:	89 04 24             	mov    %eax,(%esp)
80103ca2:	e8 89 ff ff ff       	call   80103c30 <holding>
80103ca7:	85 c0                	test   %eax,%eax
80103ca9:	75 3c                	jne    80103ce7 <acquire+0x57>
  asm volatile("lock; xchgl %0, %1" :
80103cab:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
80103cb0:	8b 55 08             	mov    0x8(%ebp),%edx
80103cb3:	89 c8                	mov    %ecx,%eax
80103cb5:	f0 87 02             	lock xchg %eax,(%edx)
80103cb8:	85 c0                	test   %eax,%eax
80103cba:	75 f4                	jne    80103cb0 <acquire+0x20>
  __sync_synchronize();
80103cbc:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103cc1:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103cc4:	e8 a7 f5 ff ff       	call   80103270 <mycpu>
80103cc9:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103ccc:	8b 45 08             	mov    0x8(%ebp),%eax
80103ccf:	83 c0 0c             	add    $0xc,%eax
80103cd2:	89 44 24 04          	mov    %eax,0x4(%esp)
80103cd6:	8d 45 08             	lea    0x8(%ebp),%eax
80103cd9:	89 04 24             	mov    %eax,(%esp)
80103cdc:	e8 03 ff ff ff       	call   80103be4 <getcallerpcs>
}
80103ce1:	83 c4 14             	add    $0x14,%esp
80103ce4:	5b                   	pop    %ebx
80103ce5:	5d                   	pop    %ebp
80103ce6:	c3                   	ret    
    panic("acquire");
80103ce7:	c7 04 24 93 72 10 80 	movl   $0x80107293,(%esp)
80103cee:	e8 1d c6 ff ff       	call   80100310 <panic>
80103cf3:	90                   	nop

80103cf4 <popcli>:

void
popcli(void)
{
80103cf4:	55                   	push   %ebp
80103cf5:	89 e5                	mov    %esp,%ebp
80103cf7:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103cfa:	9c                   	pushf  
80103cfb:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103cfc:	f6 c4 02             	test   $0x2,%ah
80103cff:	75 3d                	jne    80103d3e <popcli+0x4a>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103d01:	e8 6a f5 ff ff       	call   80103270 <mycpu>
80103d06:	ff 88 a4 00 00 00    	decl   0xa4(%eax)
80103d0c:	78 24                	js     80103d32 <popcli+0x3e>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103d0e:	e8 5d f5 ff ff       	call   80103270 <mycpu>
80103d13:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80103d19:	85 c0                	test   %eax,%eax
80103d1b:	74 03                	je     80103d20 <popcli+0x2c>
    sti();
}
80103d1d:	c9                   	leave  
80103d1e:	c3                   	ret    
80103d1f:	90                   	nop
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103d20:	e8 4b f5 ff ff       	call   80103270 <mycpu>
80103d25:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103d2b:	85 c0                	test   %eax,%eax
80103d2d:	74 ee                	je     80103d1d <popcli+0x29>
  asm volatile("sti");
80103d2f:	fb                   	sti    
}
80103d30:	c9                   	leave  
80103d31:	c3                   	ret    
    panic("popcli");
80103d32:	c7 04 24 b2 72 10 80 	movl   $0x801072b2,(%esp)
80103d39:	e8 d2 c5 ff ff       	call   80100310 <panic>
    panic("popcli - interruptible");
80103d3e:	c7 04 24 9b 72 10 80 	movl   $0x8010729b,(%esp)
80103d45:	e8 c6 c5 ff ff       	call   80100310 <panic>
80103d4a:	66 90                	xchg   %ax,%ax

80103d4c <release>:
{
80103d4c:	55                   	push   %ebp
80103d4d:	89 e5                	mov    %esp,%ebp
80103d4f:	53                   	push   %ebx
80103d50:	83 ec 14             	sub    $0x14,%esp
80103d53:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103d56:	89 1c 24             	mov    %ebx,(%esp)
80103d59:	e8 d2 fe ff ff       	call   80103c30 <holding>
80103d5e:	85 c0                	test   %eax,%eax
80103d60:	74 23                	je     80103d85 <release+0x39>
  lk->pcs[0] = 0;
80103d62:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103d69:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103d70:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103d75:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80103d7b:	83 c4 14             	add    $0x14,%esp
80103d7e:	5b                   	pop    %ebx
80103d7f:	5d                   	pop    %ebp
  popcli();
80103d80:	e9 6f ff ff ff       	jmp    80103cf4 <popcli>
    panic("release");
80103d85:	c7 04 24 b9 72 10 80 	movl   $0x801072b9,(%esp)
80103d8c:	e8 7f c5 ff ff       	call   80100310 <panic>
80103d91:	66 90                	xchg   %ax,%ax
80103d93:	90                   	nop

80103d94 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103d94:	55                   	push   %ebp
80103d95:	89 e5                	mov    %esp,%ebp
80103d97:	57                   	push   %edi
80103d98:	53                   	push   %ebx
80103d99:	8b 55 08             	mov    0x8(%ebp),%edx
  if ((int)dst%4 == 0 && n%4 == 0){
80103d9c:	f6 c2 03             	test   $0x3,%dl
80103d9f:	75 06                	jne    80103da7 <memset+0x13>
80103da1:	f6 45 10 03          	testb  $0x3,0x10(%ebp)
80103da5:	74 11                	je     80103db8 <memset+0x24>
  asm volatile("cld; rep stosb" :
80103da7:	89 d7                	mov    %edx,%edi
80103da9:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103dac:	8b 45 0c             	mov    0xc(%ebp),%eax
80103daf:	fc                   	cld    
80103db0:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80103db2:	89 d0                	mov    %edx,%eax
80103db4:	5b                   	pop    %ebx
80103db5:	5f                   	pop    %edi
80103db6:	5d                   	pop    %ebp
80103db7:	c3                   	ret    
    c &= 0xFF;
80103db8:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103dbc:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103dbf:	c1 e9 02             	shr    $0x2,%ecx
80103dc2:	89 f8                	mov    %edi,%eax
80103dc4:	c1 e0 18             	shl    $0x18,%eax
80103dc7:	89 fb                	mov    %edi,%ebx
80103dc9:	c1 e3 10             	shl    $0x10,%ebx
80103dcc:	09 d8                	or     %ebx,%eax
80103dce:	09 f8                	or     %edi,%eax
80103dd0:	c1 e7 08             	shl    $0x8,%edi
80103dd3:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103dd5:	89 d7                	mov    %edx,%edi
80103dd7:	fc                   	cld    
80103dd8:	f3 ab                	rep stos %eax,%es:(%edi)
}
80103dda:	89 d0                	mov    %edx,%eax
80103ddc:	5b                   	pop    %ebx
80103ddd:	5f                   	pop    %edi
80103dde:	5d                   	pop    %ebp
80103ddf:	c3                   	ret    

80103de0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103de0:	55                   	push   %ebp
80103de1:	89 e5                	mov    %esp,%ebp
80103de3:	57                   	push   %edi
80103de4:	56                   	push   %esi
80103de5:	53                   	push   %ebx
80103de6:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103de9:	8b 75 0c             	mov    0xc(%ebp),%esi
80103dec:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103def:	8d 78 ff             	lea    -0x1(%eax),%edi
80103df2:	85 c0                	test   %eax,%eax
80103df4:	74 20                	je     80103e16 <memcmp+0x36>
    if(*s1 != *s2)
80103df6:	0f b6 03             	movzbl (%ebx),%eax
80103df9:	0f b6 0e             	movzbl (%esi),%ecx
80103dfc:	38 c8                	cmp    %cl,%al
80103dfe:	75 20                	jne    80103e20 <memcmp+0x40>
80103e00:	31 d2                	xor    %edx,%edx
80103e02:	eb 0e                	jmp    80103e12 <memcmp+0x32>
80103e04:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
80103e09:	42                   	inc    %edx
80103e0a:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80103e0e:	38 c8                	cmp    %cl,%al
80103e10:	75 0e                	jne    80103e20 <memcmp+0x40>
  while(n-- > 0){
80103e12:	39 d7                	cmp    %edx,%edi
80103e14:	75 ee                	jne    80103e04 <memcmp+0x24>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80103e16:	31 c0                	xor    %eax,%eax
}
80103e18:	5b                   	pop    %ebx
80103e19:	5e                   	pop    %esi
80103e1a:	5f                   	pop    %edi
80103e1b:	5d                   	pop    %ebp
80103e1c:	c3                   	ret    
80103e1d:	8d 76 00             	lea    0x0(%esi),%esi
      return *s1 - *s2;
80103e20:	29 c8                	sub    %ecx,%eax
}
80103e22:	5b                   	pop    %ebx
80103e23:	5e                   	pop    %esi
80103e24:	5f                   	pop    %edi
80103e25:	5d                   	pop    %ebp
80103e26:	c3                   	ret    
80103e27:	90                   	nop

80103e28 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103e28:	55                   	push   %ebp
80103e29:	89 e5                	mov    %esp,%ebp
80103e2b:	57                   	push   %edi
80103e2c:	56                   	push   %esi
80103e2d:	53                   	push   %ebx
80103e2e:	8b 45 08             	mov    0x8(%ebp),%eax
80103e31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103e34:	39 c3                	cmp    %eax,%ebx
80103e36:	73 38                	jae    80103e70 <memmove+0x48>
80103e38:	8b 75 10             	mov    0x10(%ebp),%esi
80103e3b:	01 de                	add    %ebx,%esi
80103e3d:	39 f0                	cmp    %esi,%eax
80103e3f:	73 2f                	jae    80103e70 <memmove+0x48>
    s += n;
    d += n;
80103e41:	8b 7d 10             	mov    0x10(%ebp),%edi
80103e44:	01 c7                	add    %eax,%edi
    while(n-- > 0)
80103e46:	8b 55 10             	mov    0x10(%ebp),%edx
80103e49:	4a                   	dec    %edx
80103e4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103e4d:	85 c9                	test   %ecx,%ecx
80103e4f:	74 17                	je     80103e68 <memmove+0x40>
memmove(void *dst, const void *src, uint n)
80103e51:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103e54:	f7 d9                	neg    %ecx
80103e56:	8d 1c 0e             	lea    (%esi,%ecx,1),%ebx
80103e59:	01 cf                	add    %ecx,%edi
80103e5b:	90                   	nop
      *--d = *--s;
80103e5c:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
80103e5f:	88 0c 17             	mov    %cl,(%edi,%edx,1)
    while(n-- > 0)
80103e62:	4a                   	dec    %edx
80103e63:	83 fa ff             	cmp    $0xffffffff,%edx
80103e66:	75 f4                	jne    80103e5c <memmove+0x34>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80103e68:	5b                   	pop    %ebx
80103e69:	5e                   	pop    %esi
80103e6a:	5f                   	pop    %edi
80103e6b:	5d                   	pop    %ebp
80103e6c:	c3                   	ret    
80103e6d:	8d 76 00             	lea    0x0(%esi),%esi
    while(n-- > 0)
80103e70:	31 d2                	xor    %edx,%edx
80103e72:	8b 75 10             	mov    0x10(%ebp),%esi
80103e75:	85 f6                	test   %esi,%esi
80103e77:	74 ef                	je     80103e68 <memmove+0x40>
80103e79:	8d 76 00             	lea    0x0(%esi),%esi
      *d++ = *s++;
80103e7c:	8a 0c 13             	mov    (%ebx,%edx,1),%cl
80103e7f:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80103e82:	42                   	inc    %edx
    while(n-- > 0)
80103e83:	3b 55 10             	cmp    0x10(%ebp),%edx
80103e86:	75 f4                	jne    80103e7c <memmove+0x54>
}
80103e88:	5b                   	pop    %ebx
80103e89:	5e                   	pop    %esi
80103e8a:	5f                   	pop    %edi
80103e8b:	5d                   	pop    %ebp
80103e8c:	c3                   	ret    
80103e8d:	8d 76 00             	lea    0x0(%esi),%esi

80103e90 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103e90:	55                   	push   %ebp
80103e91:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80103e93:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80103e94:	eb 92                	jmp    80103e28 <memmove>
80103e96:	66 90                	xchg   %ax,%ax

80103e98 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80103e98:	55                   	push   %ebp
80103e99:	89 e5                	mov    %esp,%ebp
80103e9b:	57                   	push   %edi
80103e9c:	56                   	push   %esi
80103e9d:	53                   	push   %ebx
80103e9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103ea1:	8b 75 0c             	mov    0xc(%ebp),%esi
80103ea4:	8b 7d 10             	mov    0x10(%ebp),%edi
  while(n > 0 && *p && *p == *q)
80103ea7:	85 ff                	test   %edi,%edi
80103ea9:	74 2d                	je     80103ed8 <strncmp+0x40>
80103eab:	0f b6 01             	movzbl (%ecx),%eax
80103eae:	0f b6 1e             	movzbl (%esi),%ebx
80103eb1:	84 c0                	test   %al,%al
80103eb3:	74 2f                	je     80103ee4 <strncmp+0x4c>
80103eb5:	38 d8                	cmp    %bl,%al
80103eb7:	75 2b                	jne    80103ee4 <strncmp+0x4c>
strncmp(const char *p, const char *q, uint n)
80103eb9:	8d 51 01             	lea    0x1(%ecx),%edx
80103ebc:	01 cf                	add    %ecx,%edi
80103ebe:	eb 11                	jmp    80103ed1 <strncmp+0x39>
  while(n > 0 && *p && *p == *q)
80103ec0:	0f b6 02             	movzbl (%edx),%eax
80103ec3:	84 c0                	test   %al,%al
80103ec5:	74 19                	je     80103ee0 <strncmp+0x48>
80103ec7:	0f b6 19             	movzbl (%ecx),%ebx
80103eca:	42                   	inc    %edx
    n--, p++, q++;
80103ecb:	89 ce                	mov    %ecx,%esi
  while(n > 0 && *p && *p == *q)
80103ecd:	38 d8                	cmp    %bl,%al
80103ecf:	75 13                	jne    80103ee4 <strncmp+0x4c>
    n--, p++, q++;
80103ed1:	8d 4e 01             	lea    0x1(%esi),%ecx
  while(n > 0 && *p && *p == *q)
80103ed4:	39 fa                	cmp    %edi,%edx
80103ed6:	75 e8                	jne    80103ec0 <strncmp+0x28>
  if(n == 0)
    return 0;
80103ed8:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80103eda:	5b                   	pop    %ebx
80103edb:	5e                   	pop    %esi
80103edc:	5f                   	pop    %edi
80103edd:	5d                   	pop    %ebp
80103ede:	c3                   	ret    
80103edf:	90                   	nop
80103ee0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80103ee4:	29 d8                	sub    %ebx,%eax
}
80103ee6:	5b                   	pop    %ebx
80103ee7:	5e                   	pop    %esi
80103ee8:	5f                   	pop    %edi
80103ee9:	5d                   	pop    %ebp
80103eea:	c3                   	ret    
80103eeb:	90                   	nop

80103eec <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80103eec:	55                   	push   %ebp
80103eed:	89 e5                	mov    %esp,%ebp
80103eef:	57                   	push   %edi
80103ef0:	56                   	push   %esi
80103ef1:	53                   	push   %ebx
80103ef2:	8b 7d 08             	mov    0x8(%ebp),%edi
80103ef5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103ef8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80103efb:	89 fa                	mov    %edi,%edx
80103efd:	eb 0b                	jmp    80103f0a <strncpy+0x1e>
80103eff:	90                   	nop
80103f00:	8a 03                	mov    (%ebx),%al
80103f02:	88 02                	mov    %al,(%edx)
80103f04:	42                   	inc    %edx
80103f05:	43                   	inc    %ebx
80103f06:	84 c0                	test   %al,%al
80103f08:	74 08                	je     80103f12 <strncpy+0x26>
80103f0a:	49                   	dec    %ecx
strncpy(char *s, const char *t, int n)
80103f0b:	8d 71 01             	lea    0x1(%ecx),%esi
  while(n-- > 0 && (*s++ = *t++) != 0)
80103f0e:	85 f6                	test   %esi,%esi
80103f10:	7f ee                	jg     80103f00 <strncpy+0x14>
strncpy(char *s, const char *t, int n)
80103f12:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
    ;
  while(n-- > 0)
80103f15:	85 c9                	test   %ecx,%ecx
80103f17:	7e 0b                	jle    80103f24 <strncpy+0x38>
80103f19:	8d 76 00             	lea    0x0(%esi),%esi
    *s++ = 0;
80103f1c:	c6 02 00             	movb   $0x0,(%edx)
80103f1f:	42                   	inc    %edx
  while(n-- > 0)
80103f20:	39 c2                	cmp    %eax,%edx
80103f22:	75 f8                	jne    80103f1c <strncpy+0x30>
  return os;
}
80103f24:	89 f8                	mov    %edi,%eax
80103f26:	5b                   	pop    %ebx
80103f27:	5e                   	pop    %esi
80103f28:	5f                   	pop    %edi
80103f29:	5d                   	pop    %ebp
80103f2a:	c3                   	ret    
80103f2b:	90                   	nop

80103f2c <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80103f2c:	55                   	push   %ebp
80103f2d:	89 e5                	mov    %esp,%ebp
80103f2f:	56                   	push   %esi
80103f30:	53                   	push   %ebx
80103f31:	8b 45 08             	mov    0x8(%ebp),%eax
80103f34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103f37:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80103f3a:	85 d2                	test   %edx,%edx
80103f3c:	7e 17                	jle    80103f55 <safestrcpy+0x29>
safestrcpy(char *s, const char *t, int n)
80103f3e:	8d 74 10 ff          	lea    -0x1(%eax,%edx,1),%esi
80103f42:	89 c2                	mov    %eax,%edx
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80103f44:	39 f2                	cmp    %esi,%edx
80103f46:	74 0a                	je     80103f52 <safestrcpy+0x26>
80103f48:	8a 19                	mov    (%ecx),%bl
80103f4a:	88 1a                	mov    %bl,(%edx)
80103f4c:	42                   	inc    %edx
80103f4d:	41                   	inc    %ecx
80103f4e:	84 db                	test   %bl,%bl
80103f50:	75 f2                	jne    80103f44 <safestrcpy+0x18>
    ;
  *s = 0;
80103f52:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80103f55:	5b                   	pop    %ebx
80103f56:	5e                   	pop    %esi
80103f57:	5d                   	pop    %ebp
80103f58:	c3                   	ret    
80103f59:	8d 76 00             	lea    0x0(%esi),%esi

80103f5c <strlen>:

int
strlen(const char *s)
{
80103f5c:	55                   	push   %ebp
80103f5d:	89 e5                	mov    %esp,%ebp
80103f5f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80103f62:	31 c0                	xor    %eax,%eax
80103f64:	80 3a 00             	cmpb   $0x0,(%edx)
80103f67:	74 0a                	je     80103f73 <strlen+0x17>
80103f69:	8d 76 00             	lea    0x0(%esi),%esi
80103f6c:	40                   	inc    %eax
80103f6d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80103f71:	75 f9                	jne    80103f6c <strlen+0x10>
    ;
  return n;
}
80103f73:	5d                   	pop    %ebp
80103f74:	c3                   	ret    

80103f75 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80103f75:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80103f79:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80103f7d:	55                   	push   %ebp
  pushl %ebx
80103f7e:	53                   	push   %ebx
  pushl %esi
80103f7f:	56                   	push   %esi
  pushl %edi
80103f80:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80103f81:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80103f83:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80103f85:	5f                   	pop    %edi
  popl %esi
80103f86:	5e                   	pop    %esi
  popl %ebx
80103f87:	5b                   	pop    %ebx
  popl %ebp
80103f88:	5d                   	pop    %ebp
  ret
80103f89:	c3                   	ret    
80103f8a:	66 90                	xchg   %ax,%ax

80103f8c <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80103f8c:	55                   	push   %ebp
80103f8d:	89 e5                	mov    %esp,%ebp
80103f8f:	53                   	push   %ebx
80103f90:	51                   	push   %ecx
80103f91:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80103f94:	e8 7f f3 ff ff       	call   80103318 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80103f99:	8b 00                	mov    (%eax),%eax
80103f9b:	39 d8                	cmp    %ebx,%eax
80103f9d:	76 15                	jbe    80103fb4 <fetchint+0x28>
80103f9f:	8d 53 04             	lea    0x4(%ebx),%edx
80103fa2:	39 d0                	cmp    %edx,%eax
80103fa4:	72 0e                	jb     80103fb4 <fetchint+0x28>
    return -1;
  *ip = *(int*)(addr);
80103fa6:	8b 13                	mov    (%ebx),%edx
80103fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
80103fab:	89 10                	mov    %edx,(%eax)
  return 0;
80103fad:	31 c0                	xor    %eax,%eax
}
80103faf:	5a                   	pop    %edx
80103fb0:	5b                   	pop    %ebx
80103fb1:	5d                   	pop    %ebp
80103fb2:	c3                   	ret    
80103fb3:	90                   	nop
    return -1;
80103fb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fb9:	eb f4                	jmp    80103faf <fetchint+0x23>
80103fbb:	90                   	nop

80103fbc <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80103fbc:	55                   	push   %ebp
80103fbd:	89 e5                	mov    %esp,%ebp
80103fbf:	53                   	push   %ebx
80103fc0:	50                   	push   %eax
80103fc1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80103fc4:	e8 4f f3 ff ff       	call   80103318 <myproc>

  if(addr >= curproc->sz)
80103fc9:	39 18                	cmp    %ebx,(%eax)
80103fcb:	76 21                	jbe    80103fee <fetchstr+0x32>
    return -1;
  *pp = (char*)addr;
80103fcd:	89 da                	mov    %ebx,%edx
80103fcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103fd2:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80103fd4:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80103fd6:	39 c3                	cmp    %eax,%ebx
80103fd8:	73 14                	jae    80103fee <fetchstr+0x32>
    if(*s == 0)
80103fda:	80 3b 00             	cmpb   $0x0,(%ebx)
80103fdd:	75 0a                	jne    80103fe9 <fetchstr+0x2d>
80103fdf:	eb 17                	jmp    80103ff8 <fetchstr+0x3c>
80103fe1:	8d 76 00             	lea    0x0(%esi),%esi
80103fe4:	80 3a 00             	cmpb   $0x0,(%edx)
80103fe7:	74 0f                	je     80103ff8 <fetchstr+0x3c>
  for(s = *pp; s < ep; s++){
80103fe9:	42                   	inc    %edx
80103fea:	39 d0                	cmp    %edx,%eax
80103fec:	77 f6                	ja     80103fe4 <fetchstr+0x28>
    return -1;
80103fee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80103ff3:	5b                   	pop    %ebx
80103ff4:	5b                   	pop    %ebx
80103ff5:	5d                   	pop    %ebp
80103ff6:	c3                   	ret    
80103ff7:	90                   	nop
      return s - *pp;
80103ff8:	89 d0                	mov    %edx,%eax
80103ffa:	29 d8                	sub    %ebx,%eax
}
80103ffc:	5b                   	pop    %ebx
80103ffd:	5b                   	pop    %ebx
80103ffe:	5d                   	pop    %ebp
80103fff:	c3                   	ret    

80104000 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	56                   	push   %esi
80104004:	53                   	push   %ebx
80104005:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104008:	8b 75 0c             	mov    0xc(%ebp),%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010400b:	e8 08 f3 ff ff       	call   80103318 <myproc>
80104010:	89 75 0c             	mov    %esi,0xc(%ebp)
80104013:	8b 40 18             	mov    0x18(%eax),%eax
80104016:	8b 40 44             	mov    0x44(%eax),%eax
80104019:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
8010401d:	89 45 08             	mov    %eax,0x8(%ebp)
}
80104020:	5b                   	pop    %ebx
80104021:	5e                   	pop    %esi
80104022:	5d                   	pop    %ebp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104023:	e9 64 ff ff ff       	jmp    80103f8c <fetchint>

80104028 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104028:	55                   	push   %ebp
80104029:	89 e5                	mov    %esp,%ebp
8010402b:	56                   	push   %esi
8010402c:	53                   	push   %ebx
8010402d:	83 ec 20             	sub    $0x20,%esp
80104030:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104033:	e8 e0 f2 ff ff       	call   80103318 <myproc>
80104038:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
8010403a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010403d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104041:	8b 45 08             	mov    0x8(%ebp),%eax
80104044:	89 04 24             	mov    %eax,(%esp)
80104047:	e8 b4 ff ff ff       	call   80104000 <argint>
8010404c:	85 c0                	test   %eax,%eax
8010404e:	78 24                	js     80104074 <argptr+0x4c>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104050:	85 db                	test   %ebx,%ebx
80104052:	78 20                	js     80104074 <argptr+0x4c>
80104054:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104057:	8b 06                	mov    (%esi),%eax
80104059:	39 c2                	cmp    %eax,%edx
8010405b:	73 17                	jae    80104074 <argptr+0x4c>
8010405d:	01 d3                	add    %edx,%ebx
8010405f:	39 d8                	cmp    %ebx,%eax
80104061:	72 11                	jb     80104074 <argptr+0x4c>
    return -1;
  *pp = (char*)i;
80104063:	8b 45 0c             	mov    0xc(%ebp),%eax
80104066:	89 10                	mov    %edx,(%eax)
  return 0;
80104068:	31 c0                	xor    %eax,%eax
}
8010406a:	83 c4 20             	add    $0x20,%esp
8010406d:	5b                   	pop    %ebx
8010406e:	5e                   	pop    %esi
8010406f:	5d                   	pop    %ebp
80104070:	c3                   	ret    
80104071:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80104074:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104079:	83 c4 20             	add    $0x20,%esp
8010407c:	5b                   	pop    %ebx
8010407d:	5e                   	pop    %esi
8010407e:	5d                   	pop    %ebp
8010407f:	c3                   	ret    

80104080 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104080:	55                   	push   %ebp
80104081:	89 e5                	mov    %esp,%ebp
80104083:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104086:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104089:	89 44 24 04          	mov    %eax,0x4(%esp)
8010408d:	8b 45 08             	mov    0x8(%ebp),%eax
80104090:	89 04 24             	mov    %eax,(%esp)
80104093:	e8 68 ff ff ff       	call   80104000 <argint>
80104098:	85 c0                	test   %eax,%eax
8010409a:	78 14                	js     801040b0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010409c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010409f:	89 44 24 04          	mov    %eax,0x4(%esp)
801040a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040a6:	89 04 24             	mov    %eax,(%esp)
801040a9:	e8 0e ff ff ff       	call   80103fbc <fetchstr>
}
801040ae:	c9                   	leave  
801040af:	c3                   	ret    
    return -1;
801040b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801040b5:	c9                   	leave  
801040b6:	c3                   	ret    
801040b7:	90                   	nop

801040b8 <syscall>:
[SYS_set_cpu_share] sys_set_cpu_share,
};

void
syscall(void)
{
801040b8:	55                   	push   %ebp
801040b9:	89 e5                	mov    %esp,%ebp
801040bb:	53                   	push   %ebx
801040bc:	83 ec 24             	sub    $0x24,%esp
  int num;
  struct proc *curproc = myproc();
801040bf:	e8 54 f2 ff ff       	call   80103318 <myproc>

  num = curproc->tf->eax;
801040c4:	8b 58 18             	mov    0x18(%eax),%ebx
801040c7:	8b 53 1c             	mov    0x1c(%ebx),%edx
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801040ca:	8d 4a ff             	lea    -0x1(%edx),%ecx
801040cd:	83 f9 19             	cmp    $0x19,%ecx
801040d0:	77 16                	ja     801040e8 <syscall+0x30>
801040d2:	8b 0c 95 e0 72 10 80 	mov    -0x7fef8d20(,%edx,4),%ecx
801040d9:	85 c9                	test   %ecx,%ecx
801040db:	74 0b                	je     801040e8 <syscall+0x30>
    curproc->tf->eax = syscalls[num]();
801040dd:	ff d1                	call   *%ecx
801040df:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801040e2:	83 c4 24             	add    $0x24,%esp
801040e5:	5b                   	pop    %ebx
801040e6:	5d                   	pop    %ebp
801040e7:	c3                   	ret    
    cprintf("%d %s: unknown sys call %d\n",
801040e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
            curproc->pid, curproc->name, num);
801040ec:	8d 50 6c             	lea    0x6c(%eax),%edx
801040ef:	89 54 24 08          	mov    %edx,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
801040f3:	8b 50 10             	mov    0x10(%eax),%edx
801040f6:	89 54 24 04          	mov    %edx,0x4(%esp)
801040fa:	c7 04 24 c1 72 10 80 	movl   $0x801072c1,(%esp)
80104101:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104104:	e8 ab c4 ff ff       	call   801005b4 <cprintf>
    curproc->tf->eax = -1;
80104109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010410c:	8b 40 18             	mov    0x18(%eax),%eax
8010410f:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104116:	83 c4 24             	add    $0x24,%esp
80104119:	5b                   	pop    %ebx
8010411a:	5d                   	pop    %ebp
8010411b:	c3                   	ret    

8010411c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010411c:	55                   	push   %ebp
8010411d:	89 e5                	mov    %esp,%ebp
8010411f:	53                   	push   %ebx
80104120:	51                   	push   %ecx
80104121:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
80104123:	e8 f0 f1 ff ff       	call   80103318 <myproc>
80104128:	89 c1                	mov    %eax,%ecx

  for(fd = 0; fd < NOFILE; fd++){
8010412a:	31 c0                	xor    %eax,%eax
    if(curproc->ofile[fd] == 0){
8010412c:	8b 54 81 28          	mov    0x28(%ecx,%eax,4),%edx
80104130:	85 d2                	test   %edx,%edx
80104132:	74 10                	je     80104144 <fdalloc+0x28>
  for(fd = 0; fd < NOFILE; fd++){
80104134:	40                   	inc    %eax
80104135:	83 f8 10             	cmp    $0x10,%eax
80104138:	75 f2                	jne    8010412c <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010413a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010413f:	5a                   	pop    %edx
80104140:	5b                   	pop    %ebx
80104141:	5d                   	pop    %ebp
80104142:	c3                   	ret    
80104143:	90                   	nop
      curproc->ofile[fd] = f;
80104144:	89 5c 81 28          	mov    %ebx,0x28(%ecx,%eax,4)
}
80104148:	5a                   	pop    %edx
80104149:	5b                   	pop    %ebx
8010414a:	5d                   	pop    %ebp
8010414b:	c3                   	ret    

8010414c <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
8010414c:	55                   	push   %ebp
8010414d:	89 e5                	mov    %esp,%ebp
8010414f:	57                   	push   %edi
80104150:	56                   	push   %esi
80104151:	53                   	push   %ebx
80104152:	83 ec 4c             	sub    $0x4c,%esp
80104155:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
80104158:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010415b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010415e:	89 d6                	mov    %edx,%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104160:	8d 55 da             	lea    -0x26(%ebp),%edx
80104163:	89 54 24 04          	mov    %edx,0x4(%esp)
80104167:	89 04 24             	mov    %eax,(%esp)
8010416a:	e8 d1 db ff ff       	call   80101d40 <nameiparent>
8010416f:	89 c3                	mov    %eax,%ebx
80104171:	85 c0                	test   %eax,%eax
80104173:	0f 84 cf 00 00 00    	je     80104248 <create+0xfc>
    return 0;
  ilock(dp);
80104179:	89 04 24             	mov    %eax,(%esp)
8010417c:	e8 cf d3 ff ff       	call   80101550 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104181:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104184:	89 44 24 08          	mov    %eax,0x8(%esp)
80104188:	8d 4d da             	lea    -0x26(%ebp),%ecx
8010418b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
8010418f:	89 1c 24             	mov    %ebx,(%esp)
80104192:	e8 a1 d8 ff ff       	call   80101a38 <dirlookup>
80104197:	89 c7                	mov    %eax,%edi
80104199:	85 c0                	test   %eax,%eax
8010419b:	74 3b                	je     801041d8 <create+0x8c>
    iunlockput(dp);
8010419d:	89 1c 24             	mov    %ebx,(%esp)
801041a0:	e8 fb d5 ff ff       	call   801017a0 <iunlockput>
    ilock(ip);
801041a5:	89 3c 24             	mov    %edi,(%esp)
801041a8:	e8 a3 d3 ff ff       	call   80101550 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801041ad:	66 83 fe 02          	cmp    $0x2,%si
801041b1:	75 11                	jne    801041c4 <create+0x78>
801041b3:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
801041b8:	75 0a                	jne    801041c4 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801041ba:	89 f8                	mov    %edi,%eax
801041bc:	83 c4 4c             	add    $0x4c,%esp
801041bf:	5b                   	pop    %ebx
801041c0:	5e                   	pop    %esi
801041c1:	5f                   	pop    %edi
801041c2:	5d                   	pop    %ebp
801041c3:	c3                   	ret    
    iunlockput(ip);
801041c4:	89 3c 24             	mov    %edi,(%esp)
801041c7:	e8 d4 d5 ff ff       	call   801017a0 <iunlockput>
    return 0;
801041cc:	31 ff                	xor    %edi,%edi
}
801041ce:	89 f8                	mov    %edi,%eax
801041d0:	83 c4 4c             	add    $0x4c,%esp
801041d3:	5b                   	pop    %ebx
801041d4:	5e                   	pop    %esi
801041d5:	5f                   	pop    %edi
801041d6:	5d                   	pop    %ebp
801041d7:	c3                   	ret    
  if((ip = ialloc(dp->dev, type)) == 0)
801041d8:	0f bf c6             	movswl %si,%eax
801041db:	89 44 24 04          	mov    %eax,0x4(%esp)
801041df:	8b 03                	mov    (%ebx),%eax
801041e1:	89 04 24             	mov    %eax,(%esp)
801041e4:	e8 eb d1 ff ff       	call   801013d4 <ialloc>
801041e9:	89 c7                	mov    %eax,%edi
801041eb:	85 c0                	test   %eax,%eax
801041ed:	0f 84 b7 00 00 00    	je     801042aa <create+0x15e>
  ilock(ip);
801041f3:	89 04 24             	mov    %eax,(%esp)
801041f6:	e8 55 d3 ff ff       	call   80101550 <ilock>
  ip->major = major;
801041fb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801041fe:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104202:	8b 55 c0             	mov    -0x40(%ebp),%edx
80104205:	66 89 57 54          	mov    %dx,0x54(%edi)
  ip->nlink = 1;
80104209:	66 c7 47 56 01 00    	movw   $0x1,0x56(%edi)
  iupdate(ip);
8010420f:	89 3c 24             	mov    %edi,(%esp)
80104212:	e8 81 d2 ff ff       	call   80101498 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104217:	66 4e                	dec    %si
80104219:	74 35                	je     80104250 <create+0x104>
  if(dirlink(dp, name, ip->inum) < 0)
8010421b:	8b 47 04             	mov    0x4(%edi),%eax
8010421e:	89 44 24 08          	mov    %eax,0x8(%esp)
80104222:	8d 4d da             	lea    -0x26(%ebp),%ecx
80104225:	89 4c 24 04          	mov    %ecx,0x4(%esp)
80104229:	89 1c 24             	mov    %ebx,(%esp)
8010422c:	e8 1f da ff ff       	call   80101c50 <dirlink>
80104231:	85 c0                	test   %eax,%eax
80104233:	78 69                	js     8010429e <create+0x152>
  iunlockput(dp);
80104235:	89 1c 24             	mov    %ebx,(%esp)
80104238:	e8 63 d5 ff ff       	call   801017a0 <iunlockput>
}
8010423d:	89 f8                	mov    %edi,%eax
8010423f:	83 c4 4c             	add    $0x4c,%esp
80104242:	5b                   	pop    %ebx
80104243:	5e                   	pop    %esi
80104244:	5f                   	pop    %edi
80104245:	5d                   	pop    %ebp
80104246:	c3                   	ret    
80104247:	90                   	nop
    return 0;
80104248:	31 ff                	xor    %edi,%edi
8010424a:	e9 6b ff ff ff       	jmp    801041ba <create+0x6e>
8010424f:	90                   	nop
    dp->nlink++;  // for ".."
80104250:	66 ff 43 56          	incw   0x56(%ebx)
    iupdate(dp);
80104254:	89 1c 24             	mov    %ebx,(%esp)
80104257:	e8 3c d2 ff ff       	call   80101498 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010425c:	8b 47 04             	mov    0x4(%edi),%eax
8010425f:	89 44 24 08          	mov    %eax,0x8(%esp)
80104263:	c7 44 24 04 68 73 10 	movl   $0x80107368,0x4(%esp)
8010426a:	80 
8010426b:	89 3c 24             	mov    %edi,(%esp)
8010426e:	e8 dd d9 ff ff       	call   80101c50 <dirlink>
80104273:	85 c0                	test   %eax,%eax
80104275:	78 1b                	js     80104292 <create+0x146>
80104277:	8b 43 04             	mov    0x4(%ebx),%eax
8010427a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010427e:	c7 44 24 04 67 73 10 	movl   $0x80107367,0x4(%esp)
80104285:	80 
80104286:	89 3c 24             	mov    %edi,(%esp)
80104289:	e8 c2 d9 ff ff       	call   80101c50 <dirlink>
8010428e:	85 c0                	test   %eax,%eax
80104290:	79 89                	jns    8010421b <create+0xcf>
      panic("create dots");
80104292:	c7 04 24 5b 73 10 80 	movl   $0x8010735b,(%esp)
80104299:	e8 72 c0 ff ff       	call   80100310 <panic>
    panic("create: dirlink");
8010429e:	c7 04 24 6a 73 10 80 	movl   $0x8010736a,(%esp)
801042a5:	e8 66 c0 ff ff       	call   80100310 <panic>
    panic("create: ialloc");
801042aa:	c7 04 24 4c 73 10 80 	movl   $0x8010734c,(%esp)
801042b1:	e8 5a c0 ff ff       	call   80100310 <panic>
801042b6:	66 90                	xchg   %ax,%ax

801042b8 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
801042b8:	55                   	push   %ebp
801042b9:	89 e5                	mov    %esp,%ebp
801042bb:	56                   	push   %esi
801042bc:	53                   	push   %ebx
801042bd:	83 ec 20             	sub    $0x20,%esp
801042c0:	89 c6                	mov    %eax,%esi
801042c2:	89 d3                	mov    %edx,%ebx
  if(argint(n, &fd) < 0)
801042c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801042c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801042cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801042d2:	e8 29 fd ff ff       	call   80104000 <argint>
801042d7:	85 c0                	test   %eax,%eax
801042d9:	78 2d                	js     80104308 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801042db:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801042df:	77 27                	ja     80104308 <argfd.constprop.0+0x50>
801042e1:	e8 32 f0 ff ff       	call   80103318 <myproc>
801042e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042e9:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
801042ed:	85 c0                	test   %eax,%eax
801042ef:	74 17                	je     80104308 <argfd.constprop.0+0x50>
  if(pfd)
801042f1:	85 f6                	test   %esi,%esi
801042f3:	74 02                	je     801042f7 <argfd.constprop.0+0x3f>
    *pfd = fd;
801042f5:	89 16                	mov    %edx,(%esi)
  if(pf)
801042f7:	85 db                	test   %ebx,%ebx
801042f9:	74 19                	je     80104314 <argfd.constprop.0+0x5c>
    *pf = f;
801042fb:	89 03                	mov    %eax,(%ebx)
  return 0;
801042fd:	31 c0                	xor    %eax,%eax
}
801042ff:	83 c4 20             	add    $0x20,%esp
80104302:	5b                   	pop    %ebx
80104303:	5e                   	pop    %esi
80104304:	5d                   	pop    %ebp
80104305:	c3                   	ret    
80104306:	66 90                	xchg   %ax,%ax
    return -1;
80104308:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010430d:	83 c4 20             	add    $0x20,%esp
80104310:	5b                   	pop    %ebx
80104311:	5e                   	pop    %esi
80104312:	5d                   	pop    %ebp
80104313:	c3                   	ret    
  return 0;
80104314:	31 c0                	xor    %eax,%eax
80104316:	eb e7                	jmp    801042ff <argfd.constprop.0+0x47>

80104318 <sys_dup>:
{
80104318:	55                   	push   %ebp
80104319:	89 e5                	mov    %esp,%ebp
8010431b:	53                   	push   %ebx
8010431c:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
8010431f:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104322:	31 c0                	xor    %eax,%eax
80104324:	e8 8f ff ff ff       	call   801042b8 <argfd.constprop.0>
80104329:	85 c0                	test   %eax,%eax
8010432b:	78 23                	js     80104350 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
8010432d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104330:	e8 e7 fd ff ff       	call   8010411c <fdalloc>
80104335:	89 c3                	mov    %eax,%ebx
80104337:	85 c0                	test   %eax,%eax
80104339:	78 15                	js     80104350 <sys_dup+0x38>
  filedup(f);
8010433b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010433e:	89 04 24             	mov    %eax,(%esp)
80104341:	e8 b6 c9 ff ff       	call   80100cfc <filedup>
}
80104346:	89 d8                	mov    %ebx,%eax
80104348:	83 c4 24             	add    $0x24,%esp
8010434b:	5b                   	pop    %ebx
8010434c:	5d                   	pop    %ebp
8010434d:	c3                   	ret    
8010434e:	66 90                	xchg   %ax,%ax
    return -1;
80104350:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104355:	eb ef                	jmp    80104346 <sys_dup+0x2e>
80104357:	90                   	nop

80104358 <sys_read>:
{
80104358:	55                   	push   %ebp
80104359:	89 e5                	mov    %esp,%ebp
8010435b:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010435e:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104361:	31 c0                	xor    %eax,%eax
80104363:	e8 50 ff ff ff       	call   801042b8 <argfd.constprop.0>
80104368:	85 c0                	test   %eax,%eax
8010436a:	78 50                	js     801043bc <sys_read+0x64>
8010436c:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010436f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104373:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
8010437a:	e8 81 fc ff ff       	call   80104000 <argint>
8010437f:	85 c0                	test   %eax,%eax
80104381:	78 39                	js     801043bc <sys_read+0x64>
80104383:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104386:	89 44 24 08          	mov    %eax,0x8(%esp)
8010438a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010438d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104391:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104398:	e8 8b fc ff ff       	call   80104028 <argptr>
8010439d:	85 c0                	test   %eax,%eax
8010439f:	78 1b                	js     801043bc <sys_read+0x64>
  return fileread(f, p, n);
801043a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043a4:	89 44 24 08          	mov    %eax,0x8(%esp)
801043a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043ab:	89 44 24 04          	mov    %eax,0x4(%esp)
801043af:	8b 45 ec             	mov    -0x14(%ebp),%eax
801043b2:	89 04 24             	mov    %eax,(%esp)
801043b5:	e8 86 ca ff ff       	call   80100e40 <fileread>
}
801043ba:	c9                   	leave  
801043bb:	c3                   	ret    
    return -1;
801043bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043c1:	c9                   	leave  
801043c2:	c3                   	ret    
801043c3:	90                   	nop

801043c4 <sys_write>:
{
801043c4:	55                   	push   %ebp
801043c5:	89 e5                	mov    %esp,%ebp
801043c7:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801043ca:	8d 55 ec             	lea    -0x14(%ebp),%edx
801043cd:	31 c0                	xor    %eax,%eax
801043cf:	e8 e4 fe ff ff       	call   801042b8 <argfd.constprop.0>
801043d4:	85 c0                	test   %eax,%eax
801043d6:	78 50                	js     80104428 <sys_write+0x64>
801043d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801043db:	89 44 24 04          	mov    %eax,0x4(%esp)
801043df:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801043e6:	e8 15 fc ff ff       	call   80104000 <argint>
801043eb:	85 c0                	test   %eax,%eax
801043ed:	78 39                	js     80104428 <sys_write+0x64>
801043ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
801043f2:	89 44 24 08          	mov    %eax,0x8(%esp)
801043f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801043f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801043fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104404:	e8 1f fc ff ff       	call   80104028 <argptr>
80104409:	85 c0                	test   %eax,%eax
8010440b:	78 1b                	js     80104428 <sys_write+0x64>
  return filewrite(f, p, n);
8010440d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104410:	89 44 24 08          	mov    %eax,0x8(%esp)
80104414:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104417:	89 44 24 04          	mov    %eax,0x4(%esp)
8010441b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010441e:	89 04 24             	mov    %eax,(%esp)
80104421:	e8 ae ca ff ff       	call   80100ed4 <filewrite>
}
80104426:	c9                   	leave  
80104427:	c3                   	ret    
    return -1;
80104428:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010442d:	c9                   	leave  
8010442e:	c3                   	ret    
8010442f:	90                   	nop

80104430 <sys_close>:
{
80104430:	55                   	push   %ebp
80104431:	89 e5                	mov    %esp,%ebp
80104433:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
80104436:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104439:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010443c:	e8 77 fe ff ff       	call   801042b8 <argfd.constprop.0>
80104441:	85 c0                	test   %eax,%eax
80104443:	78 1f                	js     80104464 <sys_close+0x34>
  myproc()->ofile[fd] = 0;
80104445:	e8 ce ee ff ff       	call   80103318 <myproc>
8010444a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010444d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104454:	00 
  fileclose(f);
80104455:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104458:	89 04 24             	mov    %eax,(%esp)
8010445b:	e8 e0 c8 ff ff       	call   80100d40 <fileclose>
  return 0;
80104460:	31 c0                	xor    %eax,%eax
}
80104462:	c9                   	leave  
80104463:	c3                   	ret    
    return -1;
80104464:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104469:	c9                   	leave  
8010446a:	c3                   	ret    
8010446b:	90                   	nop

8010446c <sys_fstat>:
{
8010446c:	55                   	push   %ebp
8010446d:	89 e5                	mov    %esp,%ebp
8010446f:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104472:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104475:	31 c0                	xor    %eax,%eax
80104477:	e8 3c fe ff ff       	call   801042b8 <argfd.constprop.0>
8010447c:	85 c0                	test   %eax,%eax
8010447e:	78 34                	js     801044b4 <sys_fstat+0x48>
80104480:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104487:	00 
80104488:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010448b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010448f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104496:	e8 8d fb ff ff       	call   80104028 <argptr>
8010449b:	85 c0                	test   %eax,%eax
8010449d:	78 15                	js     801044b4 <sys_fstat+0x48>
  return filestat(f, st);
8010449f:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801044a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801044a9:	89 04 24             	mov    %eax,(%esp)
801044ac:	e8 43 c9 ff ff       	call   80100df4 <filestat>
}
801044b1:	c9                   	leave  
801044b2:	c3                   	ret    
801044b3:	90                   	nop
    return -1;
801044b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044b9:	c9                   	leave  
801044ba:	c3                   	ret    
801044bb:	90                   	nop

801044bc <sys_link>:
{
801044bc:	55                   	push   %ebp
801044bd:	89 e5                	mov    %esp,%ebp
801044bf:	57                   	push   %edi
801044c0:	56                   	push   %esi
801044c1:	53                   	push   %ebx
801044c2:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801044c5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801044c8:	89 44 24 04          	mov    %eax,0x4(%esp)
801044cc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801044d3:	e8 a8 fb ff ff       	call   80104080 <argstr>
801044d8:	85 c0                	test   %eax,%eax
801044da:	0f 88 e1 00 00 00    	js     801045c1 <sys_link+0x105>
801044e0:	8d 45 d0             	lea    -0x30(%ebp),%eax
801044e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801044e7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801044ee:	e8 8d fb ff ff       	call   80104080 <argstr>
801044f3:	85 c0                	test   %eax,%eax
801044f5:	0f 88 c6 00 00 00    	js     801045c1 <sys_link+0x105>
  begin_op();
801044fb:	e8 98 e2 ff ff       	call   80102798 <begin_op>
  if((ip = namei(old)) == 0){
80104500:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104503:	89 04 24             	mov    %eax,(%esp)
80104506:	e8 1d d8 ff ff       	call   80101d28 <namei>
8010450b:	89 c3                	mov    %eax,%ebx
8010450d:	85 c0                	test   %eax,%eax
8010450f:	0f 84 a7 00 00 00    	je     801045bc <sys_link+0x100>
  ilock(ip);
80104515:	89 04 24             	mov    %eax,(%esp)
80104518:	e8 33 d0 ff ff       	call   80101550 <ilock>
  if(ip->type == T_DIR){
8010451d:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104522:	0f 84 8c 00 00 00    	je     801045b4 <sys_link+0xf8>
  ip->nlink++;
80104528:	66 ff 43 56          	incw   0x56(%ebx)
  iupdate(ip);
8010452c:	89 1c 24             	mov    %ebx,(%esp)
8010452f:	e8 64 cf ff ff       	call   80101498 <iupdate>
  iunlock(ip);
80104534:	89 1c 24             	mov    %ebx,(%esp)
80104537:	e8 e4 d0 ff ff       	call   80101620 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
8010453c:	8d 7d da             	lea    -0x26(%ebp),%edi
8010453f:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104543:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104546:	89 04 24             	mov    %eax,(%esp)
80104549:	e8 f2 d7 ff ff       	call   80101d40 <nameiparent>
8010454e:	89 c6                	mov    %eax,%esi
80104550:	85 c0                	test   %eax,%eax
80104552:	74 4c                	je     801045a0 <sys_link+0xe4>
  ilock(dp);
80104554:	89 04 24             	mov    %eax,(%esp)
80104557:	e8 f4 cf ff ff       	call   80101550 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
8010455c:	8b 03                	mov    (%ebx),%eax
8010455e:	39 06                	cmp    %eax,(%esi)
80104560:	75 36                	jne    80104598 <sys_link+0xdc>
80104562:	8b 43 04             	mov    0x4(%ebx),%eax
80104565:	89 44 24 08          	mov    %eax,0x8(%esp)
80104569:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010456d:	89 34 24             	mov    %esi,(%esp)
80104570:	e8 db d6 ff ff       	call   80101c50 <dirlink>
80104575:	85 c0                	test   %eax,%eax
80104577:	78 1f                	js     80104598 <sys_link+0xdc>
  iunlockput(dp);
80104579:	89 34 24             	mov    %esi,(%esp)
8010457c:	e8 1f d2 ff ff       	call   801017a0 <iunlockput>
  iput(ip);
80104581:	89 1c 24             	mov    %ebx,(%esp)
80104584:	e8 d7 d0 ff ff       	call   80101660 <iput>
  end_op();
80104589:	e8 66 e2 ff ff       	call   801027f4 <end_op>
  return 0;
8010458e:	31 c0                	xor    %eax,%eax
}
80104590:	83 c4 3c             	add    $0x3c,%esp
80104593:	5b                   	pop    %ebx
80104594:	5e                   	pop    %esi
80104595:	5f                   	pop    %edi
80104596:	5d                   	pop    %ebp
80104597:	c3                   	ret    
    iunlockput(dp);
80104598:	89 34 24             	mov    %esi,(%esp)
8010459b:	e8 00 d2 ff ff       	call   801017a0 <iunlockput>
  ilock(ip);
801045a0:	89 1c 24             	mov    %ebx,(%esp)
801045a3:	e8 a8 cf ff ff       	call   80101550 <ilock>
  ip->nlink--;
801045a8:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
801045ac:	89 1c 24             	mov    %ebx,(%esp)
801045af:	e8 e4 ce ff ff       	call   80101498 <iupdate>
  iunlockput(ip);
801045b4:	89 1c 24             	mov    %ebx,(%esp)
801045b7:	e8 e4 d1 ff ff       	call   801017a0 <iunlockput>
  end_op();
801045bc:	e8 33 e2 ff ff       	call   801027f4 <end_op>
  return -1;
801045c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801045c6:	83 c4 3c             	add    $0x3c,%esp
801045c9:	5b                   	pop    %ebx
801045ca:	5e                   	pop    %esi
801045cb:	5f                   	pop    %edi
801045cc:	5d                   	pop    %ebp
801045cd:	c3                   	ret    
801045ce:	66 90                	xchg   %ax,%ax

801045d0 <sys_unlink>:
{
801045d0:	55                   	push   %ebp
801045d1:	89 e5                	mov    %esp,%ebp
801045d3:	57                   	push   %edi
801045d4:	56                   	push   %esi
801045d5:	53                   	push   %ebx
801045d6:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
801045d9:	8d 45 c0             	lea    -0x40(%ebp),%eax
801045dc:	89 44 24 04          	mov    %eax,0x4(%esp)
801045e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801045e7:	e8 94 fa ff ff       	call   80104080 <argstr>
801045ec:	85 c0                	test   %eax,%eax
801045ee:	0f 88 70 01 00 00    	js     80104764 <sys_unlink+0x194>
  begin_op();
801045f4:	e8 9f e1 ff ff       	call   80102798 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801045f9:	8d 5d ca             	lea    -0x36(%ebp),%ebx
801045fc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104600:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104603:	89 04 24             	mov    %eax,(%esp)
80104606:	e8 35 d7 ff ff       	call   80101d40 <nameiparent>
8010460b:	89 45 b4             	mov    %eax,-0x4c(%ebp)
8010460e:	85 c0                	test   %eax,%eax
80104610:	0f 84 49 01 00 00    	je     8010475f <sys_unlink+0x18f>
  ilock(dp);
80104616:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104619:	89 04 24             	mov    %eax,(%esp)
8010461c:	e8 2f cf ff ff       	call   80101550 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104621:	c7 44 24 04 68 73 10 	movl   $0x80107368,0x4(%esp)
80104628:	80 
80104629:	89 1c 24             	mov    %ebx,(%esp)
8010462c:	e8 e3 d3 ff ff       	call   80101a14 <namecmp>
80104631:	85 c0                	test   %eax,%eax
80104633:	0f 84 1b 01 00 00    	je     80104754 <sys_unlink+0x184>
80104639:	c7 44 24 04 67 73 10 	movl   $0x80107367,0x4(%esp)
80104640:	80 
80104641:	89 1c 24             	mov    %ebx,(%esp)
80104644:	e8 cb d3 ff ff       	call   80101a14 <namecmp>
80104649:	85 c0                	test   %eax,%eax
8010464b:	0f 84 03 01 00 00    	je     80104754 <sys_unlink+0x184>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104651:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104654:	89 44 24 08          	mov    %eax,0x8(%esp)
80104658:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010465c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
8010465f:	89 04 24             	mov    %eax,(%esp)
80104662:	e8 d1 d3 ff ff       	call   80101a38 <dirlookup>
80104667:	89 c3                	mov    %eax,%ebx
80104669:	85 c0                	test   %eax,%eax
8010466b:	0f 84 e3 00 00 00    	je     80104754 <sys_unlink+0x184>
  ilock(ip);
80104671:	89 04 24             	mov    %eax,(%esp)
80104674:	e8 d7 ce ff ff       	call   80101550 <ilock>
  if(ip->nlink < 1)
80104679:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010467e:	0f 8e 1c 01 00 00    	jle    801047a0 <sys_unlink+0x1d0>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104684:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104689:	74 7d                	je     80104708 <sys_unlink+0x138>
8010468b:	8d 75 d8             	lea    -0x28(%ebp),%esi
  memset(&de, 0, sizeof(de));
8010468e:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104695:	00 
80104696:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010469d:	00 
8010469e:	89 34 24             	mov    %esi,(%esp)
801046a1:	e8 ee f6 ff ff       	call   80103d94 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801046a6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801046ad:	00 
801046ae:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801046b1:	89 44 24 08          	mov    %eax,0x8(%esp)
801046b5:	89 74 24 04          	mov    %esi,0x4(%esp)
801046b9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801046bc:	89 04 24             	mov    %eax,(%esp)
801046bf:	e8 2c d2 ff ff       	call   801018f0 <writei>
801046c4:	83 f8 10             	cmp    $0x10,%eax
801046c7:	0f 85 c7 00 00 00    	jne    80104794 <sys_unlink+0x1c4>
  if(ip->type == T_DIR){
801046cd:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801046d2:	0f 84 9c 00 00 00    	je     80104774 <sys_unlink+0x1a4>
  iunlockput(dp);
801046d8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
801046db:	89 04 24             	mov    %eax,(%esp)
801046de:	e8 bd d0 ff ff       	call   801017a0 <iunlockput>
  ip->nlink--;
801046e3:	66 ff 4b 56          	decw   0x56(%ebx)
  iupdate(ip);
801046e7:	89 1c 24             	mov    %ebx,(%esp)
801046ea:	e8 a9 cd ff ff       	call   80101498 <iupdate>
  iunlockput(ip);
801046ef:	89 1c 24             	mov    %ebx,(%esp)
801046f2:	e8 a9 d0 ff ff       	call   801017a0 <iunlockput>
  end_op();
801046f7:	e8 f8 e0 ff ff       	call   801027f4 <end_op>
  return 0;
801046fc:	31 c0                	xor    %eax,%eax
}
801046fe:	83 c4 5c             	add    $0x5c,%esp
80104701:	5b                   	pop    %ebx
80104702:	5e                   	pop    %esi
80104703:	5f                   	pop    %edi
80104704:	5d                   	pop    %ebp
80104705:	c3                   	ret    
80104706:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104708:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
8010470c:	0f 86 79 ff ff ff    	jbe    8010468b <sys_unlink+0xbb>
80104712:	bf 20 00 00 00       	mov    $0x20,%edi
80104717:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010471a:	eb 0c                	jmp    80104728 <sys_unlink+0x158>
8010471c:	83 c7 10             	add    $0x10,%edi
8010471f:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104722:	0f 83 66 ff ff ff    	jae    8010468e <sys_unlink+0xbe>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104728:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010472f:	00 
80104730:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104734:	89 74 24 04          	mov    %esi,0x4(%esp)
80104738:	89 1c 24             	mov    %ebx,(%esp)
8010473b:	e8 ac d0 ff ff       	call   801017ec <readi>
80104740:	83 f8 10             	cmp    $0x10,%eax
80104743:	75 43                	jne    80104788 <sys_unlink+0x1b8>
    if(de.inum != 0)
80104745:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010474a:	74 d0                	je     8010471c <sys_unlink+0x14c>
    iunlockput(ip);
8010474c:	89 1c 24             	mov    %ebx,(%esp)
8010474f:	e8 4c d0 ff ff       	call   801017a0 <iunlockput>
  iunlockput(dp);
80104754:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104757:	89 04 24             	mov    %eax,(%esp)
8010475a:	e8 41 d0 ff ff       	call   801017a0 <iunlockput>
  end_op();
8010475f:	e8 90 e0 ff ff       	call   801027f4 <end_op>
  return -1;
80104764:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104769:	83 c4 5c             	add    $0x5c,%esp
8010476c:	5b                   	pop    %ebx
8010476d:	5e                   	pop    %esi
8010476e:	5f                   	pop    %edi
8010476f:	5d                   	pop    %ebp
80104770:	c3                   	ret    
80104771:	8d 76 00             	lea    0x0(%esi),%esi
    dp->nlink--;
80104774:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104777:	66 ff 48 56          	decw   0x56(%eax)
    iupdate(dp);
8010477b:	89 04 24             	mov    %eax,(%esp)
8010477e:	e8 15 cd ff ff       	call   80101498 <iupdate>
80104783:	e9 50 ff ff ff       	jmp    801046d8 <sys_unlink+0x108>
      panic("isdirempty: readi");
80104788:	c7 04 24 8c 73 10 80 	movl   $0x8010738c,(%esp)
8010478f:	e8 7c bb ff ff       	call   80100310 <panic>
    panic("unlink: writei");
80104794:	c7 04 24 9e 73 10 80 	movl   $0x8010739e,(%esp)
8010479b:	e8 70 bb ff ff       	call   80100310 <panic>
    panic("unlink: nlink < 1");
801047a0:	c7 04 24 7a 73 10 80 	movl   $0x8010737a,(%esp)
801047a7:	e8 64 bb ff ff       	call   80100310 <panic>

801047ac <sys_open>:

int
sys_open(void)
{
801047ac:	55                   	push   %ebp
801047ad:	89 e5                	mov    %esp,%ebp
801047af:	56                   	push   %esi
801047b0:	53                   	push   %ebx
801047b1:	83 ec 30             	sub    $0x30,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801047b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801047b7:	89 44 24 04          	mov    %eax,0x4(%esp)
801047bb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801047c2:	e8 b9 f8 ff ff       	call   80104080 <argstr>
801047c7:	85 c0                	test   %eax,%eax
801047c9:	0f 88 ce 00 00 00    	js     8010489d <sys_open+0xf1>
801047cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
801047d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801047d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801047dd:	e8 1e f8 ff ff       	call   80104000 <argint>
801047e2:	85 c0                	test   %eax,%eax
801047e4:	0f 88 b3 00 00 00    	js     8010489d <sys_open+0xf1>
    return -1;

  begin_op();
801047ea:	e8 a9 df ff ff       	call   80102798 <begin_op>

  if(omode & O_CREATE){
801047ef:	f6 45 f5 02          	testb  $0x2,-0xb(%ebp)
801047f3:	0f 85 83 00 00 00    	jne    8010487c <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801047f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801047fc:	89 04 24             	mov    %eax,(%esp)
801047ff:	e8 24 d5 ff ff       	call   80101d28 <namei>
80104804:	89 c6                	mov    %eax,%esi
80104806:	85 c0                	test   %eax,%eax
80104808:	0f 84 8a 00 00 00    	je     80104898 <sys_open+0xec>
      end_op();
      return -1;
    }
    ilock(ip);
8010480e:	89 04 24             	mov    %eax,(%esp)
80104811:	e8 3a cd ff ff       	call   80101550 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104816:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
8010481b:	0f 84 8b 00 00 00    	je     801048ac <sys_open+0x100>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104821:	e8 72 c4 ff ff       	call   80100c98 <filealloc>
80104826:	89 c3                	mov    %eax,%ebx
80104828:	85 c0                	test   %eax,%eax
8010482a:	0f 84 88 00 00 00    	je     801048b8 <sys_open+0x10c>
80104830:	e8 e7 f8 ff ff       	call   8010411c <fdalloc>
80104835:	85 c0                	test   %eax,%eax
80104837:	0f 88 87 00 00 00    	js     801048c4 <sys_open+0x118>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010483d:	89 34 24             	mov    %esi,(%esp)
80104840:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80104843:	e8 d8 cd ff ff       	call   80101620 <iunlock>
  end_op();
80104848:	e8 a7 df ff ff       	call   801027f4 <end_op>

  f->type = FD_INODE;
8010484d:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104853:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104856:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
8010485d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104860:	89 ca                	mov    %ecx,%edx
80104862:	83 e2 01             	and    $0x1,%edx
80104865:	83 f2 01             	xor    $0x1,%edx
80104868:	88 53 08             	mov    %dl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010486b:	83 e1 03             	and    $0x3,%ecx
8010486e:	0f 95 43 09          	setne  0x9(%ebx)
80104872:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  return fd;
}
80104875:	83 c4 30             	add    $0x30,%esp
80104878:	5b                   	pop    %ebx
80104879:	5e                   	pop    %esi
8010487a:	5d                   	pop    %ebp
8010487b:	c3                   	ret    
    ip = create(path, T_FILE, 0, 0);
8010487c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104883:	31 c9                	xor    %ecx,%ecx
80104885:	ba 02 00 00 00       	mov    $0x2,%edx
8010488a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010488d:	e8 ba f8 ff ff       	call   8010414c <create>
80104892:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104894:	85 c0                	test   %eax,%eax
80104896:	75 89                	jne    80104821 <sys_open+0x75>
    end_op();
80104898:	e8 57 df ff ff       	call   801027f4 <end_op>
    return -1;
8010489d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048a2:	83 c4 30             	add    $0x30,%esp
801048a5:	5b                   	pop    %ebx
801048a6:	5e                   	pop    %esi
801048a7:	5d                   	pop    %ebp
801048a8:	c3                   	ret    
801048a9:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801048ac:	8b 5d f4             	mov    -0xc(%ebp),%ebx
801048af:	85 db                	test   %ebx,%ebx
801048b1:	0f 84 6a ff ff ff    	je     80104821 <sys_open+0x75>
801048b7:	90                   	nop
    iunlockput(ip);
801048b8:	89 34 24             	mov    %esi,(%esp)
801048bb:	e8 e0 ce ff ff       	call   801017a0 <iunlockput>
801048c0:	eb d6                	jmp    80104898 <sys_open+0xec>
801048c2:	66 90                	xchg   %ax,%ax
      fileclose(f);
801048c4:	89 1c 24             	mov    %ebx,(%esp)
801048c7:	e8 74 c4 ff ff       	call   80100d40 <fileclose>
801048cc:	eb ea                	jmp    801048b8 <sys_open+0x10c>
801048ce:	66 90                	xchg   %ax,%ax

801048d0 <sys_mkdir>:

int
sys_mkdir(void)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801048d6:	e8 bd de ff ff       	call   80102798 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801048db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048de:	89 44 24 04          	mov    %eax,0x4(%esp)
801048e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801048e9:	e8 92 f7 ff ff       	call   80104080 <argstr>
801048ee:	85 c0                	test   %eax,%eax
801048f0:	78 2e                	js     80104920 <sys_mkdir+0x50>
801048f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801048f9:	31 c9                	xor    %ecx,%ecx
801048fb:	ba 01 00 00 00       	mov    $0x1,%edx
80104900:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104903:	e8 44 f8 ff ff       	call   8010414c <create>
80104908:	85 c0                	test   %eax,%eax
8010490a:	74 14                	je     80104920 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010490c:	89 04 24             	mov    %eax,(%esp)
8010490f:	e8 8c ce ff ff       	call   801017a0 <iunlockput>
  end_op();
80104914:	e8 db de ff ff       	call   801027f4 <end_op>
  return 0;
80104919:	31 c0                	xor    %eax,%eax
}
8010491b:	c9                   	leave  
8010491c:	c3                   	ret    
8010491d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80104920:	e8 cf de ff ff       	call   801027f4 <end_op>
    return -1;
80104925:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010492a:	c9                   	leave  
8010492b:	c3                   	ret    

8010492c <sys_mknod>:

int
sys_mknod(void)
{
8010492c:	55                   	push   %ebp
8010492d:	89 e5                	mov    %esp,%ebp
8010492f:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104932:	e8 61 de ff ff       	call   80102798 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104937:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010493a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010493e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104945:	e8 36 f7 ff ff       	call   80104080 <argstr>
8010494a:	85 c0                	test   %eax,%eax
8010494c:	78 5e                	js     801049ac <sys_mknod+0x80>
     argint(1, &major) < 0 ||
8010494e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104951:	89 44 24 04          	mov    %eax,0x4(%esp)
80104955:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010495c:	e8 9f f6 ff ff       	call   80104000 <argint>
  if((argstr(0, &path)) < 0 ||
80104961:	85 c0                	test   %eax,%eax
80104963:	78 47                	js     801049ac <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80104965:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104968:	89 44 24 04          	mov    %eax,0x4(%esp)
8010496c:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104973:	e8 88 f6 ff ff       	call   80104000 <argint>
     argint(1, &major) < 0 ||
80104978:	85 c0                	test   %eax,%eax
8010497a:	78 30                	js     801049ac <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
8010497c:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104980:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80104984:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
80104987:	ba 03 00 00 00       	mov    $0x3,%edx
8010498c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010498f:	e8 b8 f7 ff ff       	call   8010414c <create>
80104994:	85 c0                	test   %eax,%eax
80104996:	74 14                	je     801049ac <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104998:	89 04 24             	mov    %eax,(%esp)
8010499b:	e8 00 ce ff ff       	call   801017a0 <iunlockput>
  end_op();
801049a0:	e8 4f de ff ff       	call   801027f4 <end_op>
  return 0;
801049a5:	31 c0                	xor    %eax,%eax
}
801049a7:	c9                   	leave  
801049a8:	c3                   	ret    
801049a9:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
801049ac:	e8 43 de ff ff       	call   801027f4 <end_op>
    return -1;
801049b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801049b6:	c9                   	leave  
801049b7:	c3                   	ret    

801049b8 <sys_chdir>:

int
sys_chdir(void)
{
801049b8:	55                   	push   %ebp
801049b9:	89 e5                	mov    %esp,%ebp
801049bb:	56                   	push   %esi
801049bc:	53                   	push   %ebx
801049bd:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801049c0:	e8 53 e9 ff ff       	call   80103318 <myproc>
801049c5:	89 c6                	mov    %eax,%esi
  
  begin_op();
801049c7:	e8 cc dd ff ff       	call   80102798 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801049cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801049d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801049da:	e8 a1 f6 ff ff       	call   80104080 <argstr>
801049df:	85 c0                	test   %eax,%eax
801049e1:	78 4a                	js     80104a2d <sys_chdir+0x75>
801049e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e6:	89 04 24             	mov    %eax,(%esp)
801049e9:	e8 3a d3 ff ff       	call   80101d28 <namei>
801049ee:	89 c3                	mov    %eax,%ebx
801049f0:	85 c0                	test   %eax,%eax
801049f2:	74 39                	je     80104a2d <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
801049f4:	89 04 24             	mov    %eax,(%esp)
801049f7:	e8 54 cb ff ff       	call   80101550 <ilock>
  if(ip->type != T_DIR){
801049fc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80104a01:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
80104a04:	75 22                	jne    80104a28 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
80104a06:	e8 15 cc ff ff       	call   80101620 <iunlock>
  iput(curproc->cwd);
80104a0b:	8b 46 68             	mov    0x68(%esi),%eax
80104a0e:	89 04 24             	mov    %eax,(%esp)
80104a11:	e8 4a cc ff ff       	call   80101660 <iput>
  end_op();
80104a16:	e8 d9 dd ff ff       	call   801027f4 <end_op>
  curproc->cwd = ip;
80104a1b:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104a1e:	31 c0                	xor    %eax,%eax
}
80104a20:	83 c4 20             	add    $0x20,%esp
80104a23:	5b                   	pop    %ebx
80104a24:	5e                   	pop    %esi
80104a25:	5d                   	pop    %ebp
80104a26:	c3                   	ret    
80104a27:	90                   	nop
    iunlockput(ip);
80104a28:	e8 73 cd ff ff       	call   801017a0 <iunlockput>
    end_op();
80104a2d:	e8 c2 dd ff ff       	call   801027f4 <end_op>
    return -1;
80104a32:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104a37:	83 c4 20             	add    $0x20,%esp
80104a3a:	5b                   	pop    %ebx
80104a3b:	5e                   	pop    %esi
80104a3c:	5d                   	pop    %ebp
80104a3d:	c3                   	ret    
80104a3e:	66 90                	xchg   %ax,%ax

80104a40 <sys_exec>:

int
sys_exec(void)
{
80104a40:	55                   	push   %ebp
80104a41:	89 e5                	mov    %esp,%ebp
80104a43:	57                   	push   %edi
80104a44:	56                   	push   %esi
80104a45:	53                   	push   %ebx
80104a46:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80104a4c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80104a52:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a56:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104a5d:	e8 1e f6 ff ff       	call   80104080 <argstr>
80104a62:	85 c0                	test   %eax,%eax
80104a64:	0f 88 89 00 00 00    	js     80104af3 <sys_exec+0xb3>
80104a6a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80104a70:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a7b:	e8 80 f5 ff ff       	call   80104000 <argint>
80104a80:	85 c0                	test   %eax,%eax
80104a82:	78 6f                	js     80104af3 <sys_exec+0xb3>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104a84:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80104a8b:	00 
80104a8c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104a93:	00 
80104a94:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80104a9a:	89 04 24             	mov    %eax,(%esp)
80104a9d:	e8 f2 f2 ff ff       	call   80103d94 <memset>
  for(i=0;; i++){
80104aa2:	31 db                	xor    %ebx,%ebx
80104aa4:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80104aaa:	66 90                	xchg   %ax,%ax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104aac:	89 7c 24 04          	mov    %edi,0x4(%esp)
sys_exec(void)
80104ab0:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80104ab7:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80104abd:	01 f0                	add    %esi,%eax
80104abf:	89 04 24             	mov    %eax,(%esp)
80104ac2:	e8 c5 f4 ff ff       	call   80103f8c <fetchint>
80104ac7:	85 c0                	test   %eax,%eax
80104ac9:	78 28                	js     80104af3 <sys_exec+0xb3>
      return -1;
    if(uarg == 0){
80104acb:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80104ad1:	85 c0                	test   %eax,%eax
80104ad3:	74 2f                	je     80104b04 <sys_exec+0xc4>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80104ad5:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
80104adb:	01 d6                	add    %edx,%esi
80104add:	89 74 24 04          	mov    %esi,0x4(%esp)
80104ae1:	89 04 24             	mov    %eax,(%esp)
80104ae4:	e8 d3 f4 ff ff       	call   80103fbc <fetchstr>
80104ae9:	85 c0                	test   %eax,%eax
80104aeb:	78 06                	js     80104af3 <sys_exec+0xb3>
  for(i=0;; i++){
80104aed:	43                   	inc    %ebx
    if(i >= NELEM(argv))
80104aee:	83 fb 20             	cmp    $0x20,%ebx
80104af1:	75 b9                	jne    80104aac <sys_exec+0x6c>
    return -1;
80104af3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  return exec(path, argv);
}
80104af8:	81 c4 ac 00 00 00    	add    $0xac,%esp
80104afe:	5b                   	pop    %ebx
80104aff:	5e                   	pop    %esi
80104b00:	5f                   	pop    %edi
80104b01:	5d                   	pop    %ebp
80104b02:	c3                   	ret    
80104b03:	90                   	nop
      argv[i] = 0;
80104b04:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80104b0b:	00 00 00 00 
  return exec(path, argv);
80104b0f:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
80104b15:	89 54 24 04          	mov    %edx,0x4(%esp)
80104b19:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
80104b1f:	89 04 24             	mov    %eax,(%esp)
80104b22:	e8 b5 bd ff ff       	call   801008dc <exec>
}
80104b27:	81 c4 ac 00 00 00    	add    $0xac,%esp
80104b2d:	5b                   	pop    %ebx
80104b2e:	5e                   	pop    %esi
80104b2f:	5f                   	pop    %edi
80104b30:	5d                   	pop    %ebp
80104b31:	c3                   	ret    
80104b32:	66 90                	xchg   %ax,%ax

80104b34 <sys_pipe>:

int
sys_pipe(void)
{
80104b34:	55                   	push   %ebp
80104b35:	89 e5                	mov    %esp,%ebp
80104b37:	53                   	push   %ebx
80104b38:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80104b3b:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80104b42:	00 
80104b43:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104b46:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b4a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104b51:	e8 d2 f4 ff ff       	call   80104028 <argptr>
80104b56:	85 c0                	test   %eax,%eax
80104b58:	78 69                	js     80104bc3 <sys_pipe+0x8f>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80104b5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b61:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b64:	89 04 24             	mov    %eax,(%esp)
80104b67:	e8 f8 e1 ff ff       	call   80102d64 <pipealloc>
80104b6c:	85 c0                	test   %eax,%eax
80104b6e:	78 53                	js     80104bc3 <sys_pipe+0x8f>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80104b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b73:	e8 a4 f5 ff ff       	call   8010411c <fdalloc>
80104b78:	89 c3                	mov    %eax,%ebx
80104b7a:	85 c0                	test   %eax,%eax
80104b7c:	78 2f                	js     80104bad <sys_pipe+0x79>
80104b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b81:	e8 96 f5 ff ff       	call   8010411c <fdalloc>
80104b86:	85 c0                	test   %eax,%eax
80104b88:	78 16                	js     80104ba0 <sys_pipe+0x6c>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104b8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104b8d:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104b8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
80104b92:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104b95:	31 c0                	xor    %eax,%eax
}
80104b97:	83 c4 24             	add    $0x24,%esp
80104b9a:	5b                   	pop    %ebx
80104b9b:	5d                   	pop    %ebp
80104b9c:	c3                   	ret    
80104b9d:	8d 76 00             	lea    0x0(%esi),%esi
      myproc()->ofile[fd0] = 0;
80104ba0:	e8 73 e7 ff ff       	call   80103318 <myproc>
80104ba5:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104bac:	00 
    fileclose(rf);
80104bad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bb0:	89 04 24             	mov    %eax,(%esp)
80104bb3:	e8 88 c1 ff ff       	call   80100d40 <fileclose>
    fileclose(wf);
80104bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bbb:	89 04 24             	mov    %eax,(%esp)
80104bbe:	e8 7d c1 ff ff       	call   80100d40 <fileclose>
    return -1;
80104bc3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bc8:	83 c4 24             	add    $0x24,%esp
80104bcb:	5b                   	pop    %ebx
80104bcc:	5d                   	pop    %ebp
80104bcd:	c3                   	ret    
80104bce:	66 90                	xchg   %ax,%ax

80104bd0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
80104bd0:	55                   	push   %ebp
80104bd1:	89 e5                	mov    %esp,%ebp
  return fork();
}
80104bd3:	5d                   	pop    %ebp
  return fork();
80104bd4:	e9 2f e9 ff ff       	jmp    80103508 <fork>
80104bd9:	8d 76 00             	lea    0x0(%esi),%esi

80104bdc <sys_yield>:

int
sys_yield(void)
{
80104bdc:	55                   	push   %ebp
80104bdd:	89 e5                	mov    %esp,%ebp
80104bdf:	83 ec 08             	sub    $0x8,%esp
  if(myproc()->pticks)
80104be2:	e8 31 e7 ff ff       	call   80103318 <myproc>
80104be7:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80104bed:	85 c0                	test   %eax,%eax
80104bef:	74 0b                	je     80104bfc <sys_yield+0x20>
    myproc()->pticks--;
80104bf1:	e8 22 e7 ff ff       	call   80103318 <myproc>
80104bf6:	ff 88 80 00 00 00    	decl   0x80(%eax)
// For prevent gaming the scheduler - project 2
  yield();
80104bfc:	e8 c7 eb ff ff       	call   801037c8 <yield>
  return 0;
}
80104c01:	31 c0                	xor    %eax,%eax
80104c03:	c9                   	leave  
80104c04:	c3                   	ret    
80104c05:	8d 76 00             	lea    0x0(%esi),%esi

80104c08 <sys_exit>:

int
sys_exit(void)
{
80104c08:	55                   	push   %ebp
80104c09:	89 e5                	mov    %esp,%ebp
80104c0b:	83 ec 08             	sub    $0x8,%esp
  exit();
80104c0e:	e8 a5 ea ff ff       	call   801036b8 <exit>
  return 0;  // not reached
}
80104c13:	31 c0                	xor    %eax,%eax
80104c15:	c9                   	leave  
80104c16:	c3                   	ret    
80104c17:	90                   	nop

80104c18 <sys_wait>:

int
sys_wait(void)
{
80104c18:	55                   	push   %ebp
80104c19:	89 e5                	mov    %esp,%ebp
  return wait();
}
80104c1b:	5d                   	pop    %ebp
  return wait();
80104c1c:	e9 7f ec ff ff       	jmp    801038a0 <wait>
80104c21:	8d 76 00             	lea    0x0(%esi),%esi

80104c24 <sys_kill>:

int
sys_kill(void)
{
80104c24:	55                   	push   %ebp
80104c25:	89 e5                	mov    %esp,%ebp
80104c27:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80104c2a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c31:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c38:	e8 c3 f3 ff ff       	call   80104000 <argint>
80104c3d:	85 c0                	test   %eax,%eax
80104c3f:	78 0f                	js     80104c50 <sys_kill+0x2c>
    return -1;
  return kill(pid);
80104c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c44:	89 04 24             	mov    %eax,(%esp)
80104c47:	e8 60 ed ff ff       	call   801039ac <kill>
}
80104c4c:	c9                   	leave  
80104c4d:	c3                   	ret    
80104c4e:	66 90                	xchg   %ax,%ax
    return -1;
80104c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c55:	c9                   	leave  
80104c56:	c3                   	ret    
80104c57:	90                   	nop

80104c58 <sys_getpid>:

int
sys_getpid(void)
{
80104c58:	55                   	push   %ebp
80104c59:	89 e5                	mov    %esp,%ebp
80104c5b:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104c5e:	e8 b5 e6 ff ff       	call   80103318 <myproc>
80104c63:	8b 40 10             	mov    0x10(%eax),%eax
}
80104c66:	c9                   	leave  
80104c67:	c3                   	ret    

80104c68 <sys_getppid>:

int
sys_getppid(void)
{
80104c68:	55                   	push   %ebp
80104c69:	89 e5                	mov    %esp,%ebp
80104c6b:	83 ec 08             	sub    $0x8,%esp
    return myproc()->parent->pid;
80104c6e:	e8 a5 e6 ff ff       	call   80103318 <myproc>
80104c73:	8b 40 14             	mov    0x14(%eax),%eax
80104c76:	8b 40 10             	mov    0x10(%eax),%eax
}
80104c79:	c9                   	leave  
80104c7a:	c3                   	ret    
80104c7b:	90                   	nop

80104c7c <sys_getlev>:

int
sys_getlev(void)
{
80104c7c:	55                   	push   %ebp
80104c7d:	89 e5                	mov    %esp,%ebp
80104c7f:	83 ec 08             	sub    $0x8,%esp
  return myproc()->prior;
80104c82:	e8 91 e6 ff ff       	call   80103318 <myproc>
80104c87:	8b 40 7c             	mov    0x7c(%eax),%eax
}
80104c8a:	c9                   	leave  
80104c8b:	c3                   	ret    

80104c8c <sys_set_cpu_share>:

int
sys_set_cpu_share(void)
{
80104c8c:	55                   	push   %ebp
80104c8d:	89 e5                	mov    %esp,%ebp
80104c8f:	83 ec 28             	sub    $0x28,%esp
  int n;
  if(argint(0, &n) < 0)
80104c92:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c95:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c99:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ca0:	e8 5b f3 ff ff       	call   80104000 <argint>
80104ca5:	85 c0                	test   %eax,%eax
80104ca7:	78 0f                	js     80104cb8 <sys_set_cpu_share+0x2c>
    return -1;
  return set_cpu_share(n);
80104ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cac:	89 04 24             	mov    %eax,(%esp)
80104caf:	e8 d8 1c 00 00       	call   8010698c <set_cpu_share>
}
80104cb4:	c9                   	leave  
80104cb5:	c3                   	ret    
80104cb6:	66 90                	xchg   %ax,%ax
    return -1;
80104cb8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104cbd:	c9                   	leave  
80104cbe:	c3                   	ret    
80104cbf:	90                   	nop

80104cc0 <sys_sbrk>:

int
sys_sbrk(void)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	53                   	push   %ebx
80104cc4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80104cc7:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104cca:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cce:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104cd5:	e8 26 f3 ff ff       	call   80104000 <argint>
80104cda:	85 c0                	test   %eax,%eax
80104cdc:	78 1e                	js     80104cfc <sys_sbrk+0x3c>
    return -1;
  addr = myproc()->sz;
80104cde:	e8 35 e6 ff ff       	call   80103318 <myproc>
80104ce3:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80104ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ce8:	89 04 24             	mov    %eax,(%esp)
80104ceb:	e8 ac e7 ff ff       	call   8010349c <growproc>
80104cf0:	85 c0                	test   %eax,%eax
80104cf2:	78 08                	js     80104cfc <sys_sbrk+0x3c>
    return -1;
  return addr;
}
80104cf4:	89 d8                	mov    %ebx,%eax
80104cf6:	83 c4 24             	add    $0x24,%esp
80104cf9:	5b                   	pop    %ebx
80104cfa:	5d                   	pop    %ebp
80104cfb:	c3                   	ret    
    return -1;
80104cfc:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104d01:	eb f1                	jmp    80104cf4 <sys_sbrk+0x34>
80104d03:	90                   	nop

80104d04 <sys_sleep>:

int
sys_sleep(void)
{
80104d04:	55                   	push   %ebp
80104d05:	89 e5                	mov    %esp,%ebp
80104d07:	53                   	push   %ebx
80104d08:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80104d0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104d12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104d19:	e8 e2 f2 ff ff       	call   80104000 <argint>
80104d1e:	85 c0                	test   %eax,%eax
80104d20:	78 76                	js     80104d98 <sys_sleep+0x94>
    return -1;
  acquire(&tickslock);
80104d22:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80104d29:	e8 62 ef ff ff       	call   80103c90 <acquire>
  ticks0 = ticks;
80104d2e:	8b 1d a0 57 11 80    	mov    0x801157a0,%ebx
  while(ticks - ticks0 < n){
80104d34:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104d37:	85 c9                	test   %ecx,%ecx
80104d39:	75 25                	jne    80104d60 <sys_sleep+0x5c>
80104d3b:	eb 47                	jmp    80104d84 <sys_sleep+0x80>
80104d3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104d40:	c7 44 24 04 60 4f 11 	movl   $0x80114f60,0x4(%esp)
80104d47:	80 
80104d48:	c7 04 24 a0 57 11 80 	movl   $0x801157a0,(%esp)
80104d4f:	e8 a8 ea ff ff       	call   801037fc <sleep>
  while(ticks - ticks0 < n){
80104d54:	a1 a0 57 11 80       	mov    0x801157a0,%eax
80104d59:	29 d8                	sub    %ebx,%eax
80104d5b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104d5e:	73 24                	jae    80104d84 <sys_sleep+0x80>
    if(myproc()->killed){
80104d60:	e8 b3 e5 ff ff       	call   80103318 <myproc>
80104d65:	8b 50 24             	mov    0x24(%eax),%edx
80104d68:	85 d2                	test   %edx,%edx
80104d6a:	74 d4                	je     80104d40 <sys_sleep+0x3c>
      release(&tickslock);
80104d6c:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80104d73:	e8 d4 ef ff ff       	call   80103d4c <release>
      return -1;
80104d78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80104d7d:	83 c4 24             	add    $0x24,%esp
80104d80:	5b                   	pop    %ebx
80104d81:	5d                   	pop    %ebp
80104d82:	c3                   	ret    
80104d83:	90                   	nop
  release(&tickslock);
80104d84:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80104d8b:	e8 bc ef ff ff       	call   80103d4c <release>
  return 0;
80104d90:	31 c0                	xor    %eax,%eax
}
80104d92:	83 c4 24             	add    $0x24,%esp
80104d95:	5b                   	pop    %ebx
80104d96:	5d                   	pop    %ebp
80104d97:	c3                   	ret    
    return -1;
80104d98:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d9d:	eb de                	jmp    80104d7d <sys_sleep+0x79>
80104d9f:	90                   	nop

80104da0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	53                   	push   %ebx
80104da4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80104da7:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80104dae:	e8 dd ee ff ff       	call   80103c90 <acquire>
  xticks = ticks;
80104db3:	8b 1d a0 57 11 80    	mov    0x801157a0,%ebx
  release(&tickslock);
80104db9:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80104dc0:	e8 87 ef ff ff       	call   80103d4c <release>
  return xticks;
}
80104dc5:	89 d8                	mov    %ebx,%eax
80104dc7:	83 c4 14             	add    $0x14,%esp
80104dca:	5b                   	pop    %ebx
80104dcb:	5d                   	pop    %ebp
80104dcc:	c3                   	ret    

80104dcd <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80104dcd:	1e                   	push   %ds
  pushl %es
80104dce:	06                   	push   %es
  pushl %fs
80104dcf:	0f a0                	push   %fs
  pushl %gs
80104dd1:	0f a8                	push   %gs
  pushal
80104dd3:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80104dd4:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80104dd8:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80104dda:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80104ddc:	54                   	push   %esp
  call trap
80104ddd:	e8 ba 00 00 00       	call   80104e9c <trap>
  addl $4, %esp
80104de2:	83 c4 04             	add    $0x4,%esp

80104de5 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80104de5:	61                   	popa   
  popl %gs
80104de6:	0f a9                	pop    %gs
  popl %fs
80104de8:	0f a1                	pop    %fs
  popl %es
80104dea:	07                   	pop    %es
  popl %ds
80104deb:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80104dec:	83 c4 08             	add    $0x8,%esp
  iret
80104def:	cf                   	iret   

80104df0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80104df0:	31 c0                	xor    %eax,%eax
80104df2:	66 90                	xchg   %ax,%ax
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80104df4:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
80104dfb:	66 89 14 c5 a0 4f 11 	mov    %dx,-0x7feeb060(,%eax,8)
80104e02:	80 
80104e03:	66 c7 04 c5 a2 4f 11 	movw   $0x8,-0x7feeb05e(,%eax,8)
80104e0a:	80 08 00 
80104e0d:	c6 04 c5 a4 4f 11 80 	movb   $0x0,-0x7feeb05c(,%eax,8)
80104e14:	00 
80104e15:	c6 04 c5 a5 4f 11 80 	movb   $0x8e,-0x7feeb05b(,%eax,8)
80104e1c:	8e 
80104e1d:	c1 ea 10             	shr    $0x10,%edx
80104e20:	66 89 14 c5 a6 4f 11 	mov    %dx,-0x7feeb05a(,%eax,8)
80104e27:	80 
  for(i = 0; i < 256; i++)
80104e28:	40                   	inc    %eax
80104e29:	3d 00 01 00 00       	cmp    $0x100,%eax
80104e2e:	75 c4                	jne    80104df4 <tvinit+0x4>
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80104e36:	a1 08 a1 10 80       	mov    0x8010a108,%eax
80104e3b:	66 a3 a0 51 11 80    	mov    %ax,0x801151a0
80104e41:	66 c7 05 a2 51 11 80 	movw   $0x8,0x801151a2
80104e48:	08 00 
80104e4a:	c6 05 a4 51 11 80 00 	movb   $0x0,0x801151a4
80104e51:	c6 05 a5 51 11 80 ef 	movb   $0xef,0x801151a5
80104e58:	c1 e8 10             	shr    $0x10,%eax
80104e5b:	66 a3 a6 51 11 80    	mov    %ax,0x801151a6

  initlock(&tickslock, "time");
80104e61:	c7 44 24 04 ad 73 10 	movl   $0x801073ad,0x4(%esp)
80104e68:	80 
80104e69:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80104e70:	e8 53 ed ff ff       	call   80103bc8 <initlock>
}
80104e75:	c9                   	leave  
80104e76:	c3                   	ret    
80104e77:	90                   	nop

80104e78 <idtinit>:

void
idtinit(void)
{
80104e78:	55                   	push   %ebp
80104e79:	89 e5                	mov    %esp,%ebp
80104e7b:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80104e7e:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80104e84:	b8 a0 4f 11 80       	mov    $0x80114fa0,%eax
80104e89:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80104e8d:	c1 e8 10             	shr    $0x10,%eax
80104e90:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80104e94:	8d 45 fa             	lea    -0x6(%ebp),%eax
80104e97:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80104e9a:	c9                   	leave  
80104e9b:	c3                   	ret    

80104e9c <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80104e9c:	55                   	push   %ebp
80104e9d:	89 e5                	mov    %esp,%ebp
80104e9f:	57                   	push   %edi
80104ea0:	56                   	push   %esi
80104ea1:	53                   	push   %ebx
80104ea2:	83 ec 3c             	sub    $0x3c,%esp
80104ea5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80104ea8:	8b 43 30             	mov    0x30(%ebx),%eax
80104eab:	83 f8 40             	cmp    $0x40,%eax
80104eae:	0f 84 c0 01 00 00    	je     80105074 <trap+0x1d8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80104eb4:	83 e8 20             	sub    $0x20,%eax
80104eb7:	83 f8 1f             	cmp    $0x1f,%eax
80104eba:	0f 86 f4 00 00 00    	jbe    80104fb4 <trap+0x118>
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80104ec0:	e8 53 e4 ff ff       	call   80103318 <myproc>
80104ec5:	85 c0                	test   %eax,%eax
80104ec7:	0f 84 f2 01 00 00    	je     801050bf <trap+0x223>
80104ecd:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80104ed1:	0f 84 e8 01 00 00    	je     801050bf <trap+0x223>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80104ed7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80104eda:	8b 53 38             	mov    0x38(%ebx),%edx
80104edd:	89 55 dc             	mov    %edx,-0x24(%ebp)
80104ee0:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80104ee3:	e8 fc e3 ff ff       	call   801032e4 <cpuid>
80104ee8:	89 c7                	mov    %eax,%edi
80104eea:	8b 73 34             	mov    0x34(%ebx),%esi
80104eed:	8b 43 30             	mov    0x30(%ebx),%eax
80104ef0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80104ef3:	e8 20 e4 ff ff       	call   80103318 <myproc>
80104ef8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104efb:	e8 18 e4 ff ff       	call   80103318 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80104f00:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80104f03:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
80104f07:	8b 55 dc             	mov    -0x24(%ebp),%edx
80104f0a:	89 54 24 18          	mov    %edx,0x18(%esp)
80104f0e:	89 7c 24 14          	mov    %edi,0x14(%esp)
80104f12:	89 74 24 10          	mov    %esi,0x10(%esp)
80104f16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104f19:	89 54 24 0c          	mov    %edx,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80104f1d:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104f20:	83 c2 6c             	add    $0x6c,%edx
80104f23:	89 54 24 08          	mov    %edx,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80104f27:	8b 40 10             	mov    0x10(%eax),%eax
80104f2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f2e:	c7 04 24 10 74 10 80 	movl   $0x80107410,(%esp)
80104f35:	e8 7a b6 ff ff       	call   801005b4 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80104f3a:	e8 d9 e3 ff ff       	call   80103318 <myproc>
80104f3f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80104f46:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80104f48:	e8 cb e3 ff ff       	call   80103318 <myproc>
80104f4d:	85 c0                	test   %eax,%eax
80104f4f:	74 1c                	je     80104f6d <trap+0xd1>
80104f51:	e8 c2 e3 ff ff       	call   80103318 <myproc>
80104f56:	8b 50 24             	mov    0x24(%eax),%edx
80104f59:	85 d2                	test   %edx,%edx
80104f5b:	74 10                	je     80104f6d <trap+0xd1>
80104f5d:	8b 43 3c             	mov    0x3c(%ebx),%eax
80104f60:	83 e0 03             	and    $0x3,%eax
80104f63:	66 83 f8 03          	cmp    $0x3,%ax
80104f67:	0f 84 3f 01 00 00    	je     801050ac <trap+0x210>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80104f6d:	e8 a6 e3 ff ff       	call   80103318 <myproc>
80104f72:	85 c0                	test   %eax,%eax
80104f74:	74 0f                	je     80104f85 <trap+0xe9>
80104f76:	e8 9d e3 ff ff       	call   80103318 <myproc>
80104f7b:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80104f7f:	0f 84 cb 00 00 00    	je     80105050 <trap+0x1b4>
    if(MLFQ_tick_adder()){
      yield();
    }   
  }
  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80104f85:	e8 8e e3 ff ff       	call   80103318 <myproc>
80104f8a:	85 c0                	test   %eax,%eax
80104f8c:	74 1c                	je     80104faa <trap+0x10e>
80104f8e:	e8 85 e3 ff ff       	call   80103318 <myproc>
80104f93:	8b 40 24             	mov    0x24(%eax),%eax
80104f96:	85 c0                	test   %eax,%eax
80104f98:	74 10                	je     80104faa <trap+0x10e>
80104f9a:	8b 43 3c             	mov    0x3c(%ebx),%eax
80104f9d:	83 e0 03             	and    $0x3,%eax
80104fa0:	66 83 f8 03          	cmp    $0x3,%ax
80104fa4:	0f 84 f3 00 00 00    	je     8010509d <trap+0x201>
    exit();
}
80104faa:	83 c4 3c             	add    $0x3c,%esp
80104fad:	5b                   	pop    %ebx
80104fae:	5e                   	pop    %esi
80104faf:	5f                   	pop    %edi
80104fb0:	5d                   	pop    %ebp
80104fb1:	c3                   	ret    
80104fb2:	66 90                	xchg   %ax,%ax
  switch(tf->trapno){
80104fb4:	ff 24 85 54 74 10 80 	jmp    *-0x7fef8bac(,%eax,4)
80104fbb:	90                   	nop
    ideintr();
80104fbc:	e8 ab ce ff ff       	call   80101e6c <ideintr>
    lapiceoi();
80104fc1:	e8 b2 d4 ff ff       	call   80102478 <lapiceoi>
    break;
80104fc6:	eb 80                	jmp    80104f48 <trap+0xac>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80104fc8:	8b 7b 38             	mov    0x38(%ebx),%edi
80104fcb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80104fcf:	e8 10 e3 ff ff       	call   801032e4 <cpuid>
80104fd4:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80104fd8:	89 74 24 08          	mov    %esi,0x8(%esp)
80104fdc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fe0:	c7 04 24 b8 73 10 80 	movl   $0x801073b8,(%esp)
80104fe7:	e8 c8 b5 ff ff       	call   801005b4 <cprintf>
    lapiceoi();
80104fec:	e8 87 d4 ff ff       	call   80102478 <lapiceoi>
    break;
80104ff1:	e9 52 ff ff ff       	jmp    80104f48 <trap+0xac>
80104ff6:	66 90                	xchg   %ax,%ax
    uartintr();
80104ff8:	e8 fb 01 00 00       	call   801051f8 <uartintr>
    lapiceoi();
80104ffd:	e8 76 d4 ff ff       	call   80102478 <lapiceoi>
    break;
80105002:	e9 41 ff ff ff       	jmp    80104f48 <trap+0xac>
80105007:	90                   	nop
    kbdintr();
80105008:	e8 f7 d2 ff ff       	call   80102304 <kbdintr>
    lapiceoi();
8010500d:	e8 66 d4 ff ff       	call   80102478 <lapiceoi>
    break;
80105012:	e9 31 ff ff ff       	jmp    80104f48 <trap+0xac>
80105017:	90                   	nop
    if(cpuid() == 0){
80105018:	e8 c7 e2 ff ff       	call   801032e4 <cpuid>
8010501d:	85 c0                	test   %eax,%eax
8010501f:	75 a0                	jne    80104fc1 <trap+0x125>
      acquire(&tickslock);
80105021:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80105028:	e8 63 ec ff ff       	call   80103c90 <acquire>
      ticks++;
8010502d:	ff 05 a0 57 11 80    	incl   0x801157a0
      wakeup(&ticks);
80105033:	c7 04 24 a0 57 11 80 	movl   $0x801157a0,(%esp)
8010503a:	e8 3d e9 ff ff       	call   8010397c <wakeup>
      release(&tickslock);
8010503f:	c7 04 24 60 4f 11 80 	movl   $0x80114f60,(%esp)
80105046:	e8 01 ed ff ff       	call   80103d4c <release>
8010504b:	e9 71 ff ff ff       	jmp    80104fc1 <trap+0x125>
  if(myproc() && myproc()->state == RUNNING &&
80105050:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105054:	0f 85 2b ff ff ff    	jne    80104f85 <trap+0xe9>
    if(MLFQ_tick_adder()){
8010505a:	e8 b1 1a 00 00       	call   80106b10 <MLFQ_tick_adder>
8010505f:	85 c0                	test   %eax,%eax
80105061:	0f 84 1e ff ff ff    	je     80104f85 <trap+0xe9>
      yield();
80105067:	e8 5c e7 ff ff       	call   801037c8 <yield>
8010506c:	e9 14 ff ff ff       	jmp    80104f85 <trap+0xe9>
80105071:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc()->killed)
80105074:	e8 9f e2 ff ff       	call   80103318 <myproc>
80105079:	8b 70 24             	mov    0x24(%eax),%esi
8010507c:	85 f6                	test   %esi,%esi
8010507e:	75 38                	jne    801050b8 <trap+0x21c>
    myproc()->tf = tf;
80105080:	e8 93 e2 ff ff       	call   80103318 <myproc>
80105085:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105088:	e8 2b f0 ff ff       	call   801040b8 <syscall>
    if(myproc()->killed)
8010508d:	e8 86 e2 ff ff       	call   80103318 <myproc>
80105092:	8b 48 24             	mov    0x24(%eax),%ecx
80105095:	85 c9                	test   %ecx,%ecx
80105097:	0f 84 0d ff ff ff    	je     80104faa <trap+0x10e>
}
8010509d:	83 c4 3c             	add    $0x3c,%esp
801050a0:	5b                   	pop    %ebx
801050a1:	5e                   	pop    %esi
801050a2:	5f                   	pop    %edi
801050a3:	5d                   	pop    %ebp
      exit();
801050a4:	e9 0f e6 ff ff       	jmp    801036b8 <exit>
801050a9:	8d 76 00             	lea    0x0(%esi),%esi
    exit();
801050ac:	e8 07 e6 ff ff       	call   801036b8 <exit>
801050b1:	e9 b7 fe ff ff       	jmp    80104f6d <trap+0xd1>
801050b6:	66 90                	xchg   %ax,%ax
      exit();
801050b8:	e8 fb e5 ff ff       	call   801036b8 <exit>
801050bd:	eb c1                	jmp    80105080 <trap+0x1e4>
801050bf:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801050c2:	8b 73 38             	mov    0x38(%ebx),%esi
801050c5:	e8 1a e2 ff ff       	call   801032e4 <cpuid>
801050ca:	89 7c 24 10          	mov    %edi,0x10(%esp)
801050ce:	89 74 24 0c          	mov    %esi,0xc(%esp)
801050d2:	89 44 24 08          	mov    %eax,0x8(%esp)
801050d6:	8b 43 30             	mov    0x30(%ebx),%eax
801050d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801050dd:	c7 04 24 dc 73 10 80 	movl   $0x801073dc,(%esp)
801050e4:	e8 cb b4 ff ff       	call   801005b4 <cprintf>
      panic("trap");
801050e9:	c7 04 24 b2 73 10 80 	movl   $0x801073b2,(%esp)
801050f0:	e8 1b b2 ff ff       	call   80100310 <panic>
801050f5:	66 90                	xchg   %ax,%ax
801050f7:	90                   	nop

801050f8 <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801050f8:	55                   	push   %ebp
801050f9:	89 e5                	mov    %esp,%ebp
  if(!uart)
801050fb:	a1 a4 a5 10 80       	mov    0x8010a5a4,%eax
80105100:	85 c0                	test   %eax,%eax
80105102:	74 14                	je     80105118 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105104:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105109:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010510a:	a8 01                	test   $0x1,%al
8010510c:	74 0a                	je     80105118 <uartgetc+0x20>
8010510e:	b2 f8                	mov    $0xf8,%dl
80105110:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105111:	0f b6 c0             	movzbl %al,%eax
}
80105114:	5d                   	pop    %ebp
80105115:	c3                   	ret    
80105116:	66 90                	xchg   %ax,%ax
    return -1;
80105118:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010511d:	5d                   	pop    %ebp
8010511e:	c3                   	ret    
8010511f:	90                   	nop

80105120 <uartputc>:
  if(!uart)
80105120:	8b 15 a4 a5 10 80    	mov    0x8010a5a4,%edx
80105126:	85 d2                	test   %edx,%edx
80105128:	74 3c                	je     80105166 <uartputc+0x46>
{
8010512a:	55                   	push   %ebp
8010512b:	89 e5                	mov    %esp,%ebp
8010512d:	56                   	push   %esi
8010512e:	53                   	push   %ebx
8010512f:	83 ec 10             	sub    $0x10,%esp
  if(!uart)
80105132:	bb 80 00 00 00       	mov    $0x80,%ebx
80105137:	be fd 03 00 00       	mov    $0x3fd,%esi
8010513c:	eb 11                	jmp    8010514f <uartputc+0x2f>
8010513e:	66 90                	xchg   %ax,%ax
    microdelay(10);
80105140:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105147:	e8 48 d3 ff ff       	call   80102494 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010514c:	4b                   	dec    %ebx
8010514d:	74 07                	je     80105156 <uartputc+0x36>
8010514f:	89 f2                	mov    %esi,%edx
80105151:	ec                   	in     (%dx),%al
80105152:	a8 20                	test   $0x20,%al
80105154:	74 ea                	je     80105140 <uartputc+0x20>
  outb(COM1+0, c);
80105156:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010515a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010515f:	ee                   	out    %al,(%dx)
}
80105160:	83 c4 10             	add    $0x10,%esp
80105163:	5b                   	pop    %ebx
80105164:	5e                   	pop    %esi
80105165:	5d                   	pop    %ebp
80105166:	c3                   	ret    
80105167:	90                   	nop

80105168 <uartinit>:
{
80105168:	55                   	push   %ebp
80105169:	89 e5                	mov    %esp,%ebp
8010516b:	57                   	push   %edi
8010516c:	56                   	push   %esi
8010516d:	53                   	push   %ebx
8010516e:	83 ec 1c             	sub    $0x1c,%esp
80105171:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105176:	31 c0                	xor    %eax,%eax
80105178:	89 fa                	mov    %edi,%edx
8010517a:	ee                   	out    %al,(%dx)
8010517b:	bb fb 03 00 00       	mov    $0x3fb,%ebx
80105180:	b0 80                	mov    $0x80,%al
80105182:	89 da                	mov    %ebx,%edx
80105184:	ee                   	out    %al,(%dx)
80105185:	be f8 03 00 00       	mov    $0x3f8,%esi
8010518a:	b0 0c                	mov    $0xc,%al
8010518c:	89 f2                	mov    %esi,%edx
8010518e:	ee                   	out    %al,(%dx)
8010518f:	b9 f9 03 00 00       	mov    $0x3f9,%ecx
80105194:	31 c0                	xor    %eax,%eax
80105196:	89 ca                	mov    %ecx,%edx
80105198:	ee                   	out    %al,(%dx)
80105199:	b0 03                	mov    $0x3,%al
8010519b:	89 da                	mov    %ebx,%edx
8010519d:	ee                   	out    %al,(%dx)
8010519e:	b2 fc                	mov    $0xfc,%dl
801051a0:	31 c0                	xor    %eax,%eax
801051a2:	ee                   	out    %al,(%dx)
801051a3:	b0 01                	mov    $0x1,%al
801051a5:	89 ca                	mov    %ecx,%edx
801051a7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801051a8:	b2 fd                	mov    $0xfd,%dl
801051aa:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801051ab:	fe c0                	inc    %al
801051ad:	74 41                	je     801051f0 <uartinit+0x88>
  uart = 1;
801051af:	c7 05 a4 a5 10 80 01 	movl   $0x1,0x8010a5a4
801051b6:	00 00 00 
801051b9:	89 fa                	mov    %edi,%edx
801051bb:	ec                   	in     (%dx),%al
801051bc:	89 f2                	mov    %esi,%edx
801051be:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801051bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801051c6:	00 
801051c7:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
801051ce:	e8 a9 ce ff ff       	call   8010207c <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801051d3:	b8 78 00 00 00       	mov    $0x78,%eax
801051d8:	bb d4 74 10 80       	mov    $0x801074d4,%ebx
801051dd:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(*p);
801051e0:	89 04 24             	mov    %eax,(%esp)
801051e3:	e8 38 ff ff ff       	call   80105120 <uartputc>
  for(p="xv6...\n"; *p; p++)
801051e8:	43                   	inc    %ebx
801051e9:	0f be 03             	movsbl (%ebx),%eax
801051ec:	84 c0                	test   %al,%al
801051ee:	75 f0                	jne    801051e0 <uartinit+0x78>
}
801051f0:	83 c4 1c             	add    $0x1c,%esp
801051f3:	5b                   	pop    %ebx
801051f4:	5e                   	pop    %esi
801051f5:	5f                   	pop    %edi
801051f6:	5d                   	pop    %ebp
801051f7:	c3                   	ret    

801051f8 <uartintr>:

void
uartintr(void)
{
801051f8:	55                   	push   %ebp
801051f9:	89 e5                	mov    %esp,%ebp
801051fb:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
801051fe:	c7 04 24 f8 50 10 80 	movl   $0x801050f8,(%esp)
80105205:	e8 f6 b4 ff ff       	call   80100700 <consoleintr>
}
8010520a:	c9                   	leave  
8010520b:	c3                   	ret    

8010520c <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010520c:	6a 00                	push   $0x0
  pushl $0
8010520e:	6a 00                	push   $0x0
  jmp alltraps
80105210:	e9 b8 fb ff ff       	jmp    80104dcd <alltraps>

80105215 <vector1>:
.globl vector1
vector1:
  pushl $0
80105215:	6a 00                	push   $0x0
  pushl $1
80105217:	6a 01                	push   $0x1
  jmp alltraps
80105219:	e9 af fb ff ff       	jmp    80104dcd <alltraps>

8010521e <vector2>:
.globl vector2
vector2:
  pushl $0
8010521e:	6a 00                	push   $0x0
  pushl $2
80105220:	6a 02                	push   $0x2
  jmp alltraps
80105222:	e9 a6 fb ff ff       	jmp    80104dcd <alltraps>

80105227 <vector3>:
.globl vector3
vector3:
  pushl $0
80105227:	6a 00                	push   $0x0
  pushl $3
80105229:	6a 03                	push   $0x3
  jmp alltraps
8010522b:	e9 9d fb ff ff       	jmp    80104dcd <alltraps>

80105230 <vector4>:
.globl vector4
vector4:
  pushl $0
80105230:	6a 00                	push   $0x0
  pushl $4
80105232:	6a 04                	push   $0x4
  jmp alltraps
80105234:	e9 94 fb ff ff       	jmp    80104dcd <alltraps>

80105239 <vector5>:
.globl vector5
vector5:
  pushl $0
80105239:	6a 00                	push   $0x0
  pushl $5
8010523b:	6a 05                	push   $0x5
  jmp alltraps
8010523d:	e9 8b fb ff ff       	jmp    80104dcd <alltraps>

80105242 <vector6>:
.globl vector6
vector6:
  pushl $0
80105242:	6a 00                	push   $0x0
  pushl $6
80105244:	6a 06                	push   $0x6
  jmp alltraps
80105246:	e9 82 fb ff ff       	jmp    80104dcd <alltraps>

8010524b <vector7>:
.globl vector7
vector7:
  pushl $0
8010524b:	6a 00                	push   $0x0
  pushl $7
8010524d:	6a 07                	push   $0x7
  jmp alltraps
8010524f:	e9 79 fb ff ff       	jmp    80104dcd <alltraps>

80105254 <vector8>:
.globl vector8
vector8:
  pushl $8
80105254:	6a 08                	push   $0x8
  jmp alltraps
80105256:	e9 72 fb ff ff       	jmp    80104dcd <alltraps>

8010525b <vector9>:
.globl vector9
vector9:
  pushl $0
8010525b:	6a 00                	push   $0x0
  pushl $9
8010525d:	6a 09                	push   $0x9
  jmp alltraps
8010525f:	e9 69 fb ff ff       	jmp    80104dcd <alltraps>

80105264 <vector10>:
.globl vector10
vector10:
  pushl $10
80105264:	6a 0a                	push   $0xa
  jmp alltraps
80105266:	e9 62 fb ff ff       	jmp    80104dcd <alltraps>

8010526b <vector11>:
.globl vector11
vector11:
  pushl $11
8010526b:	6a 0b                	push   $0xb
  jmp alltraps
8010526d:	e9 5b fb ff ff       	jmp    80104dcd <alltraps>

80105272 <vector12>:
.globl vector12
vector12:
  pushl $12
80105272:	6a 0c                	push   $0xc
  jmp alltraps
80105274:	e9 54 fb ff ff       	jmp    80104dcd <alltraps>

80105279 <vector13>:
.globl vector13
vector13:
  pushl $13
80105279:	6a 0d                	push   $0xd
  jmp alltraps
8010527b:	e9 4d fb ff ff       	jmp    80104dcd <alltraps>

80105280 <vector14>:
.globl vector14
vector14:
  pushl $14
80105280:	6a 0e                	push   $0xe
  jmp alltraps
80105282:	e9 46 fb ff ff       	jmp    80104dcd <alltraps>

80105287 <vector15>:
.globl vector15
vector15:
  pushl $0
80105287:	6a 00                	push   $0x0
  pushl $15
80105289:	6a 0f                	push   $0xf
  jmp alltraps
8010528b:	e9 3d fb ff ff       	jmp    80104dcd <alltraps>

80105290 <vector16>:
.globl vector16
vector16:
  pushl $0
80105290:	6a 00                	push   $0x0
  pushl $16
80105292:	6a 10                	push   $0x10
  jmp alltraps
80105294:	e9 34 fb ff ff       	jmp    80104dcd <alltraps>

80105299 <vector17>:
.globl vector17
vector17:
  pushl $17
80105299:	6a 11                	push   $0x11
  jmp alltraps
8010529b:	e9 2d fb ff ff       	jmp    80104dcd <alltraps>

801052a0 <vector18>:
.globl vector18
vector18:
  pushl $0
801052a0:	6a 00                	push   $0x0
  pushl $18
801052a2:	6a 12                	push   $0x12
  jmp alltraps
801052a4:	e9 24 fb ff ff       	jmp    80104dcd <alltraps>

801052a9 <vector19>:
.globl vector19
vector19:
  pushl $0
801052a9:	6a 00                	push   $0x0
  pushl $19
801052ab:	6a 13                	push   $0x13
  jmp alltraps
801052ad:	e9 1b fb ff ff       	jmp    80104dcd <alltraps>

801052b2 <vector20>:
.globl vector20
vector20:
  pushl $0
801052b2:	6a 00                	push   $0x0
  pushl $20
801052b4:	6a 14                	push   $0x14
  jmp alltraps
801052b6:	e9 12 fb ff ff       	jmp    80104dcd <alltraps>

801052bb <vector21>:
.globl vector21
vector21:
  pushl $0
801052bb:	6a 00                	push   $0x0
  pushl $21
801052bd:	6a 15                	push   $0x15
  jmp alltraps
801052bf:	e9 09 fb ff ff       	jmp    80104dcd <alltraps>

801052c4 <vector22>:
.globl vector22
vector22:
  pushl $0
801052c4:	6a 00                	push   $0x0
  pushl $22
801052c6:	6a 16                	push   $0x16
  jmp alltraps
801052c8:	e9 00 fb ff ff       	jmp    80104dcd <alltraps>

801052cd <vector23>:
.globl vector23
vector23:
  pushl $0
801052cd:	6a 00                	push   $0x0
  pushl $23
801052cf:	6a 17                	push   $0x17
  jmp alltraps
801052d1:	e9 f7 fa ff ff       	jmp    80104dcd <alltraps>

801052d6 <vector24>:
.globl vector24
vector24:
  pushl $0
801052d6:	6a 00                	push   $0x0
  pushl $24
801052d8:	6a 18                	push   $0x18
  jmp alltraps
801052da:	e9 ee fa ff ff       	jmp    80104dcd <alltraps>

801052df <vector25>:
.globl vector25
vector25:
  pushl $0
801052df:	6a 00                	push   $0x0
  pushl $25
801052e1:	6a 19                	push   $0x19
  jmp alltraps
801052e3:	e9 e5 fa ff ff       	jmp    80104dcd <alltraps>

801052e8 <vector26>:
.globl vector26
vector26:
  pushl $0
801052e8:	6a 00                	push   $0x0
  pushl $26
801052ea:	6a 1a                	push   $0x1a
  jmp alltraps
801052ec:	e9 dc fa ff ff       	jmp    80104dcd <alltraps>

801052f1 <vector27>:
.globl vector27
vector27:
  pushl $0
801052f1:	6a 00                	push   $0x0
  pushl $27
801052f3:	6a 1b                	push   $0x1b
  jmp alltraps
801052f5:	e9 d3 fa ff ff       	jmp    80104dcd <alltraps>

801052fa <vector28>:
.globl vector28
vector28:
  pushl $0
801052fa:	6a 00                	push   $0x0
  pushl $28
801052fc:	6a 1c                	push   $0x1c
  jmp alltraps
801052fe:	e9 ca fa ff ff       	jmp    80104dcd <alltraps>

80105303 <vector29>:
.globl vector29
vector29:
  pushl $0
80105303:	6a 00                	push   $0x0
  pushl $29
80105305:	6a 1d                	push   $0x1d
  jmp alltraps
80105307:	e9 c1 fa ff ff       	jmp    80104dcd <alltraps>

8010530c <vector30>:
.globl vector30
vector30:
  pushl $0
8010530c:	6a 00                	push   $0x0
  pushl $30
8010530e:	6a 1e                	push   $0x1e
  jmp alltraps
80105310:	e9 b8 fa ff ff       	jmp    80104dcd <alltraps>

80105315 <vector31>:
.globl vector31
vector31:
  pushl $0
80105315:	6a 00                	push   $0x0
  pushl $31
80105317:	6a 1f                	push   $0x1f
  jmp alltraps
80105319:	e9 af fa ff ff       	jmp    80104dcd <alltraps>

8010531e <vector32>:
.globl vector32
vector32:
  pushl $0
8010531e:	6a 00                	push   $0x0
  pushl $32
80105320:	6a 20                	push   $0x20
  jmp alltraps
80105322:	e9 a6 fa ff ff       	jmp    80104dcd <alltraps>

80105327 <vector33>:
.globl vector33
vector33:
  pushl $0
80105327:	6a 00                	push   $0x0
  pushl $33
80105329:	6a 21                	push   $0x21
  jmp alltraps
8010532b:	e9 9d fa ff ff       	jmp    80104dcd <alltraps>

80105330 <vector34>:
.globl vector34
vector34:
  pushl $0
80105330:	6a 00                	push   $0x0
  pushl $34
80105332:	6a 22                	push   $0x22
  jmp alltraps
80105334:	e9 94 fa ff ff       	jmp    80104dcd <alltraps>

80105339 <vector35>:
.globl vector35
vector35:
  pushl $0
80105339:	6a 00                	push   $0x0
  pushl $35
8010533b:	6a 23                	push   $0x23
  jmp alltraps
8010533d:	e9 8b fa ff ff       	jmp    80104dcd <alltraps>

80105342 <vector36>:
.globl vector36
vector36:
  pushl $0
80105342:	6a 00                	push   $0x0
  pushl $36
80105344:	6a 24                	push   $0x24
  jmp alltraps
80105346:	e9 82 fa ff ff       	jmp    80104dcd <alltraps>

8010534b <vector37>:
.globl vector37
vector37:
  pushl $0
8010534b:	6a 00                	push   $0x0
  pushl $37
8010534d:	6a 25                	push   $0x25
  jmp alltraps
8010534f:	e9 79 fa ff ff       	jmp    80104dcd <alltraps>

80105354 <vector38>:
.globl vector38
vector38:
  pushl $0
80105354:	6a 00                	push   $0x0
  pushl $38
80105356:	6a 26                	push   $0x26
  jmp alltraps
80105358:	e9 70 fa ff ff       	jmp    80104dcd <alltraps>

8010535d <vector39>:
.globl vector39
vector39:
  pushl $0
8010535d:	6a 00                	push   $0x0
  pushl $39
8010535f:	6a 27                	push   $0x27
  jmp alltraps
80105361:	e9 67 fa ff ff       	jmp    80104dcd <alltraps>

80105366 <vector40>:
.globl vector40
vector40:
  pushl $0
80105366:	6a 00                	push   $0x0
  pushl $40
80105368:	6a 28                	push   $0x28
  jmp alltraps
8010536a:	e9 5e fa ff ff       	jmp    80104dcd <alltraps>

8010536f <vector41>:
.globl vector41
vector41:
  pushl $0
8010536f:	6a 00                	push   $0x0
  pushl $41
80105371:	6a 29                	push   $0x29
  jmp alltraps
80105373:	e9 55 fa ff ff       	jmp    80104dcd <alltraps>

80105378 <vector42>:
.globl vector42
vector42:
  pushl $0
80105378:	6a 00                	push   $0x0
  pushl $42
8010537a:	6a 2a                	push   $0x2a
  jmp alltraps
8010537c:	e9 4c fa ff ff       	jmp    80104dcd <alltraps>

80105381 <vector43>:
.globl vector43
vector43:
  pushl $0
80105381:	6a 00                	push   $0x0
  pushl $43
80105383:	6a 2b                	push   $0x2b
  jmp alltraps
80105385:	e9 43 fa ff ff       	jmp    80104dcd <alltraps>

8010538a <vector44>:
.globl vector44
vector44:
  pushl $0
8010538a:	6a 00                	push   $0x0
  pushl $44
8010538c:	6a 2c                	push   $0x2c
  jmp alltraps
8010538e:	e9 3a fa ff ff       	jmp    80104dcd <alltraps>

80105393 <vector45>:
.globl vector45
vector45:
  pushl $0
80105393:	6a 00                	push   $0x0
  pushl $45
80105395:	6a 2d                	push   $0x2d
  jmp alltraps
80105397:	e9 31 fa ff ff       	jmp    80104dcd <alltraps>

8010539c <vector46>:
.globl vector46
vector46:
  pushl $0
8010539c:	6a 00                	push   $0x0
  pushl $46
8010539e:	6a 2e                	push   $0x2e
  jmp alltraps
801053a0:	e9 28 fa ff ff       	jmp    80104dcd <alltraps>

801053a5 <vector47>:
.globl vector47
vector47:
  pushl $0
801053a5:	6a 00                	push   $0x0
  pushl $47
801053a7:	6a 2f                	push   $0x2f
  jmp alltraps
801053a9:	e9 1f fa ff ff       	jmp    80104dcd <alltraps>

801053ae <vector48>:
.globl vector48
vector48:
  pushl $0
801053ae:	6a 00                	push   $0x0
  pushl $48
801053b0:	6a 30                	push   $0x30
  jmp alltraps
801053b2:	e9 16 fa ff ff       	jmp    80104dcd <alltraps>

801053b7 <vector49>:
.globl vector49
vector49:
  pushl $0
801053b7:	6a 00                	push   $0x0
  pushl $49
801053b9:	6a 31                	push   $0x31
  jmp alltraps
801053bb:	e9 0d fa ff ff       	jmp    80104dcd <alltraps>

801053c0 <vector50>:
.globl vector50
vector50:
  pushl $0
801053c0:	6a 00                	push   $0x0
  pushl $50
801053c2:	6a 32                	push   $0x32
  jmp alltraps
801053c4:	e9 04 fa ff ff       	jmp    80104dcd <alltraps>

801053c9 <vector51>:
.globl vector51
vector51:
  pushl $0
801053c9:	6a 00                	push   $0x0
  pushl $51
801053cb:	6a 33                	push   $0x33
  jmp alltraps
801053cd:	e9 fb f9 ff ff       	jmp    80104dcd <alltraps>

801053d2 <vector52>:
.globl vector52
vector52:
  pushl $0
801053d2:	6a 00                	push   $0x0
  pushl $52
801053d4:	6a 34                	push   $0x34
  jmp alltraps
801053d6:	e9 f2 f9 ff ff       	jmp    80104dcd <alltraps>

801053db <vector53>:
.globl vector53
vector53:
  pushl $0
801053db:	6a 00                	push   $0x0
  pushl $53
801053dd:	6a 35                	push   $0x35
  jmp alltraps
801053df:	e9 e9 f9 ff ff       	jmp    80104dcd <alltraps>

801053e4 <vector54>:
.globl vector54
vector54:
  pushl $0
801053e4:	6a 00                	push   $0x0
  pushl $54
801053e6:	6a 36                	push   $0x36
  jmp alltraps
801053e8:	e9 e0 f9 ff ff       	jmp    80104dcd <alltraps>

801053ed <vector55>:
.globl vector55
vector55:
  pushl $0
801053ed:	6a 00                	push   $0x0
  pushl $55
801053ef:	6a 37                	push   $0x37
  jmp alltraps
801053f1:	e9 d7 f9 ff ff       	jmp    80104dcd <alltraps>

801053f6 <vector56>:
.globl vector56
vector56:
  pushl $0
801053f6:	6a 00                	push   $0x0
  pushl $56
801053f8:	6a 38                	push   $0x38
  jmp alltraps
801053fa:	e9 ce f9 ff ff       	jmp    80104dcd <alltraps>

801053ff <vector57>:
.globl vector57
vector57:
  pushl $0
801053ff:	6a 00                	push   $0x0
  pushl $57
80105401:	6a 39                	push   $0x39
  jmp alltraps
80105403:	e9 c5 f9 ff ff       	jmp    80104dcd <alltraps>

80105408 <vector58>:
.globl vector58
vector58:
  pushl $0
80105408:	6a 00                	push   $0x0
  pushl $58
8010540a:	6a 3a                	push   $0x3a
  jmp alltraps
8010540c:	e9 bc f9 ff ff       	jmp    80104dcd <alltraps>

80105411 <vector59>:
.globl vector59
vector59:
  pushl $0
80105411:	6a 00                	push   $0x0
  pushl $59
80105413:	6a 3b                	push   $0x3b
  jmp alltraps
80105415:	e9 b3 f9 ff ff       	jmp    80104dcd <alltraps>

8010541a <vector60>:
.globl vector60
vector60:
  pushl $0
8010541a:	6a 00                	push   $0x0
  pushl $60
8010541c:	6a 3c                	push   $0x3c
  jmp alltraps
8010541e:	e9 aa f9 ff ff       	jmp    80104dcd <alltraps>

80105423 <vector61>:
.globl vector61
vector61:
  pushl $0
80105423:	6a 00                	push   $0x0
  pushl $61
80105425:	6a 3d                	push   $0x3d
  jmp alltraps
80105427:	e9 a1 f9 ff ff       	jmp    80104dcd <alltraps>

8010542c <vector62>:
.globl vector62
vector62:
  pushl $0
8010542c:	6a 00                	push   $0x0
  pushl $62
8010542e:	6a 3e                	push   $0x3e
  jmp alltraps
80105430:	e9 98 f9 ff ff       	jmp    80104dcd <alltraps>

80105435 <vector63>:
.globl vector63
vector63:
  pushl $0
80105435:	6a 00                	push   $0x0
  pushl $63
80105437:	6a 3f                	push   $0x3f
  jmp alltraps
80105439:	e9 8f f9 ff ff       	jmp    80104dcd <alltraps>

8010543e <vector64>:
.globl vector64
vector64:
  pushl $0
8010543e:	6a 00                	push   $0x0
  pushl $64
80105440:	6a 40                	push   $0x40
  jmp alltraps
80105442:	e9 86 f9 ff ff       	jmp    80104dcd <alltraps>

80105447 <vector65>:
.globl vector65
vector65:
  pushl $0
80105447:	6a 00                	push   $0x0
  pushl $65
80105449:	6a 41                	push   $0x41
  jmp alltraps
8010544b:	e9 7d f9 ff ff       	jmp    80104dcd <alltraps>

80105450 <vector66>:
.globl vector66
vector66:
  pushl $0
80105450:	6a 00                	push   $0x0
  pushl $66
80105452:	6a 42                	push   $0x42
  jmp alltraps
80105454:	e9 74 f9 ff ff       	jmp    80104dcd <alltraps>

80105459 <vector67>:
.globl vector67
vector67:
  pushl $0
80105459:	6a 00                	push   $0x0
  pushl $67
8010545b:	6a 43                	push   $0x43
  jmp alltraps
8010545d:	e9 6b f9 ff ff       	jmp    80104dcd <alltraps>

80105462 <vector68>:
.globl vector68
vector68:
  pushl $0
80105462:	6a 00                	push   $0x0
  pushl $68
80105464:	6a 44                	push   $0x44
  jmp alltraps
80105466:	e9 62 f9 ff ff       	jmp    80104dcd <alltraps>

8010546b <vector69>:
.globl vector69
vector69:
  pushl $0
8010546b:	6a 00                	push   $0x0
  pushl $69
8010546d:	6a 45                	push   $0x45
  jmp alltraps
8010546f:	e9 59 f9 ff ff       	jmp    80104dcd <alltraps>

80105474 <vector70>:
.globl vector70
vector70:
  pushl $0
80105474:	6a 00                	push   $0x0
  pushl $70
80105476:	6a 46                	push   $0x46
  jmp alltraps
80105478:	e9 50 f9 ff ff       	jmp    80104dcd <alltraps>

8010547d <vector71>:
.globl vector71
vector71:
  pushl $0
8010547d:	6a 00                	push   $0x0
  pushl $71
8010547f:	6a 47                	push   $0x47
  jmp alltraps
80105481:	e9 47 f9 ff ff       	jmp    80104dcd <alltraps>

80105486 <vector72>:
.globl vector72
vector72:
  pushl $0
80105486:	6a 00                	push   $0x0
  pushl $72
80105488:	6a 48                	push   $0x48
  jmp alltraps
8010548a:	e9 3e f9 ff ff       	jmp    80104dcd <alltraps>

8010548f <vector73>:
.globl vector73
vector73:
  pushl $0
8010548f:	6a 00                	push   $0x0
  pushl $73
80105491:	6a 49                	push   $0x49
  jmp alltraps
80105493:	e9 35 f9 ff ff       	jmp    80104dcd <alltraps>

80105498 <vector74>:
.globl vector74
vector74:
  pushl $0
80105498:	6a 00                	push   $0x0
  pushl $74
8010549a:	6a 4a                	push   $0x4a
  jmp alltraps
8010549c:	e9 2c f9 ff ff       	jmp    80104dcd <alltraps>

801054a1 <vector75>:
.globl vector75
vector75:
  pushl $0
801054a1:	6a 00                	push   $0x0
  pushl $75
801054a3:	6a 4b                	push   $0x4b
  jmp alltraps
801054a5:	e9 23 f9 ff ff       	jmp    80104dcd <alltraps>

801054aa <vector76>:
.globl vector76
vector76:
  pushl $0
801054aa:	6a 00                	push   $0x0
  pushl $76
801054ac:	6a 4c                	push   $0x4c
  jmp alltraps
801054ae:	e9 1a f9 ff ff       	jmp    80104dcd <alltraps>

801054b3 <vector77>:
.globl vector77
vector77:
  pushl $0
801054b3:	6a 00                	push   $0x0
  pushl $77
801054b5:	6a 4d                	push   $0x4d
  jmp alltraps
801054b7:	e9 11 f9 ff ff       	jmp    80104dcd <alltraps>

801054bc <vector78>:
.globl vector78
vector78:
  pushl $0
801054bc:	6a 00                	push   $0x0
  pushl $78
801054be:	6a 4e                	push   $0x4e
  jmp alltraps
801054c0:	e9 08 f9 ff ff       	jmp    80104dcd <alltraps>

801054c5 <vector79>:
.globl vector79
vector79:
  pushl $0
801054c5:	6a 00                	push   $0x0
  pushl $79
801054c7:	6a 4f                	push   $0x4f
  jmp alltraps
801054c9:	e9 ff f8 ff ff       	jmp    80104dcd <alltraps>

801054ce <vector80>:
.globl vector80
vector80:
  pushl $0
801054ce:	6a 00                	push   $0x0
  pushl $80
801054d0:	6a 50                	push   $0x50
  jmp alltraps
801054d2:	e9 f6 f8 ff ff       	jmp    80104dcd <alltraps>

801054d7 <vector81>:
.globl vector81
vector81:
  pushl $0
801054d7:	6a 00                	push   $0x0
  pushl $81
801054d9:	6a 51                	push   $0x51
  jmp alltraps
801054db:	e9 ed f8 ff ff       	jmp    80104dcd <alltraps>

801054e0 <vector82>:
.globl vector82
vector82:
  pushl $0
801054e0:	6a 00                	push   $0x0
  pushl $82
801054e2:	6a 52                	push   $0x52
  jmp alltraps
801054e4:	e9 e4 f8 ff ff       	jmp    80104dcd <alltraps>

801054e9 <vector83>:
.globl vector83
vector83:
  pushl $0
801054e9:	6a 00                	push   $0x0
  pushl $83
801054eb:	6a 53                	push   $0x53
  jmp alltraps
801054ed:	e9 db f8 ff ff       	jmp    80104dcd <alltraps>

801054f2 <vector84>:
.globl vector84
vector84:
  pushl $0
801054f2:	6a 00                	push   $0x0
  pushl $84
801054f4:	6a 54                	push   $0x54
  jmp alltraps
801054f6:	e9 d2 f8 ff ff       	jmp    80104dcd <alltraps>

801054fb <vector85>:
.globl vector85
vector85:
  pushl $0
801054fb:	6a 00                	push   $0x0
  pushl $85
801054fd:	6a 55                	push   $0x55
  jmp alltraps
801054ff:	e9 c9 f8 ff ff       	jmp    80104dcd <alltraps>

80105504 <vector86>:
.globl vector86
vector86:
  pushl $0
80105504:	6a 00                	push   $0x0
  pushl $86
80105506:	6a 56                	push   $0x56
  jmp alltraps
80105508:	e9 c0 f8 ff ff       	jmp    80104dcd <alltraps>

8010550d <vector87>:
.globl vector87
vector87:
  pushl $0
8010550d:	6a 00                	push   $0x0
  pushl $87
8010550f:	6a 57                	push   $0x57
  jmp alltraps
80105511:	e9 b7 f8 ff ff       	jmp    80104dcd <alltraps>

80105516 <vector88>:
.globl vector88
vector88:
  pushl $0
80105516:	6a 00                	push   $0x0
  pushl $88
80105518:	6a 58                	push   $0x58
  jmp alltraps
8010551a:	e9 ae f8 ff ff       	jmp    80104dcd <alltraps>

8010551f <vector89>:
.globl vector89
vector89:
  pushl $0
8010551f:	6a 00                	push   $0x0
  pushl $89
80105521:	6a 59                	push   $0x59
  jmp alltraps
80105523:	e9 a5 f8 ff ff       	jmp    80104dcd <alltraps>

80105528 <vector90>:
.globl vector90
vector90:
  pushl $0
80105528:	6a 00                	push   $0x0
  pushl $90
8010552a:	6a 5a                	push   $0x5a
  jmp alltraps
8010552c:	e9 9c f8 ff ff       	jmp    80104dcd <alltraps>

80105531 <vector91>:
.globl vector91
vector91:
  pushl $0
80105531:	6a 00                	push   $0x0
  pushl $91
80105533:	6a 5b                	push   $0x5b
  jmp alltraps
80105535:	e9 93 f8 ff ff       	jmp    80104dcd <alltraps>

8010553a <vector92>:
.globl vector92
vector92:
  pushl $0
8010553a:	6a 00                	push   $0x0
  pushl $92
8010553c:	6a 5c                	push   $0x5c
  jmp alltraps
8010553e:	e9 8a f8 ff ff       	jmp    80104dcd <alltraps>

80105543 <vector93>:
.globl vector93
vector93:
  pushl $0
80105543:	6a 00                	push   $0x0
  pushl $93
80105545:	6a 5d                	push   $0x5d
  jmp alltraps
80105547:	e9 81 f8 ff ff       	jmp    80104dcd <alltraps>

8010554c <vector94>:
.globl vector94
vector94:
  pushl $0
8010554c:	6a 00                	push   $0x0
  pushl $94
8010554e:	6a 5e                	push   $0x5e
  jmp alltraps
80105550:	e9 78 f8 ff ff       	jmp    80104dcd <alltraps>

80105555 <vector95>:
.globl vector95
vector95:
  pushl $0
80105555:	6a 00                	push   $0x0
  pushl $95
80105557:	6a 5f                	push   $0x5f
  jmp alltraps
80105559:	e9 6f f8 ff ff       	jmp    80104dcd <alltraps>

8010555e <vector96>:
.globl vector96
vector96:
  pushl $0
8010555e:	6a 00                	push   $0x0
  pushl $96
80105560:	6a 60                	push   $0x60
  jmp alltraps
80105562:	e9 66 f8 ff ff       	jmp    80104dcd <alltraps>

80105567 <vector97>:
.globl vector97
vector97:
  pushl $0
80105567:	6a 00                	push   $0x0
  pushl $97
80105569:	6a 61                	push   $0x61
  jmp alltraps
8010556b:	e9 5d f8 ff ff       	jmp    80104dcd <alltraps>

80105570 <vector98>:
.globl vector98
vector98:
  pushl $0
80105570:	6a 00                	push   $0x0
  pushl $98
80105572:	6a 62                	push   $0x62
  jmp alltraps
80105574:	e9 54 f8 ff ff       	jmp    80104dcd <alltraps>

80105579 <vector99>:
.globl vector99
vector99:
  pushl $0
80105579:	6a 00                	push   $0x0
  pushl $99
8010557b:	6a 63                	push   $0x63
  jmp alltraps
8010557d:	e9 4b f8 ff ff       	jmp    80104dcd <alltraps>

80105582 <vector100>:
.globl vector100
vector100:
  pushl $0
80105582:	6a 00                	push   $0x0
  pushl $100
80105584:	6a 64                	push   $0x64
  jmp alltraps
80105586:	e9 42 f8 ff ff       	jmp    80104dcd <alltraps>

8010558b <vector101>:
.globl vector101
vector101:
  pushl $0
8010558b:	6a 00                	push   $0x0
  pushl $101
8010558d:	6a 65                	push   $0x65
  jmp alltraps
8010558f:	e9 39 f8 ff ff       	jmp    80104dcd <alltraps>

80105594 <vector102>:
.globl vector102
vector102:
  pushl $0
80105594:	6a 00                	push   $0x0
  pushl $102
80105596:	6a 66                	push   $0x66
  jmp alltraps
80105598:	e9 30 f8 ff ff       	jmp    80104dcd <alltraps>

8010559d <vector103>:
.globl vector103
vector103:
  pushl $0
8010559d:	6a 00                	push   $0x0
  pushl $103
8010559f:	6a 67                	push   $0x67
  jmp alltraps
801055a1:	e9 27 f8 ff ff       	jmp    80104dcd <alltraps>

801055a6 <vector104>:
.globl vector104
vector104:
  pushl $0
801055a6:	6a 00                	push   $0x0
  pushl $104
801055a8:	6a 68                	push   $0x68
  jmp alltraps
801055aa:	e9 1e f8 ff ff       	jmp    80104dcd <alltraps>

801055af <vector105>:
.globl vector105
vector105:
  pushl $0
801055af:	6a 00                	push   $0x0
  pushl $105
801055b1:	6a 69                	push   $0x69
  jmp alltraps
801055b3:	e9 15 f8 ff ff       	jmp    80104dcd <alltraps>

801055b8 <vector106>:
.globl vector106
vector106:
  pushl $0
801055b8:	6a 00                	push   $0x0
  pushl $106
801055ba:	6a 6a                	push   $0x6a
  jmp alltraps
801055bc:	e9 0c f8 ff ff       	jmp    80104dcd <alltraps>

801055c1 <vector107>:
.globl vector107
vector107:
  pushl $0
801055c1:	6a 00                	push   $0x0
  pushl $107
801055c3:	6a 6b                	push   $0x6b
  jmp alltraps
801055c5:	e9 03 f8 ff ff       	jmp    80104dcd <alltraps>

801055ca <vector108>:
.globl vector108
vector108:
  pushl $0
801055ca:	6a 00                	push   $0x0
  pushl $108
801055cc:	6a 6c                	push   $0x6c
  jmp alltraps
801055ce:	e9 fa f7 ff ff       	jmp    80104dcd <alltraps>

801055d3 <vector109>:
.globl vector109
vector109:
  pushl $0
801055d3:	6a 00                	push   $0x0
  pushl $109
801055d5:	6a 6d                	push   $0x6d
  jmp alltraps
801055d7:	e9 f1 f7 ff ff       	jmp    80104dcd <alltraps>

801055dc <vector110>:
.globl vector110
vector110:
  pushl $0
801055dc:	6a 00                	push   $0x0
  pushl $110
801055de:	6a 6e                	push   $0x6e
  jmp alltraps
801055e0:	e9 e8 f7 ff ff       	jmp    80104dcd <alltraps>

801055e5 <vector111>:
.globl vector111
vector111:
  pushl $0
801055e5:	6a 00                	push   $0x0
  pushl $111
801055e7:	6a 6f                	push   $0x6f
  jmp alltraps
801055e9:	e9 df f7 ff ff       	jmp    80104dcd <alltraps>

801055ee <vector112>:
.globl vector112
vector112:
  pushl $0
801055ee:	6a 00                	push   $0x0
  pushl $112
801055f0:	6a 70                	push   $0x70
  jmp alltraps
801055f2:	e9 d6 f7 ff ff       	jmp    80104dcd <alltraps>

801055f7 <vector113>:
.globl vector113
vector113:
  pushl $0
801055f7:	6a 00                	push   $0x0
  pushl $113
801055f9:	6a 71                	push   $0x71
  jmp alltraps
801055fb:	e9 cd f7 ff ff       	jmp    80104dcd <alltraps>

80105600 <vector114>:
.globl vector114
vector114:
  pushl $0
80105600:	6a 00                	push   $0x0
  pushl $114
80105602:	6a 72                	push   $0x72
  jmp alltraps
80105604:	e9 c4 f7 ff ff       	jmp    80104dcd <alltraps>

80105609 <vector115>:
.globl vector115
vector115:
  pushl $0
80105609:	6a 00                	push   $0x0
  pushl $115
8010560b:	6a 73                	push   $0x73
  jmp alltraps
8010560d:	e9 bb f7 ff ff       	jmp    80104dcd <alltraps>

80105612 <vector116>:
.globl vector116
vector116:
  pushl $0
80105612:	6a 00                	push   $0x0
  pushl $116
80105614:	6a 74                	push   $0x74
  jmp alltraps
80105616:	e9 b2 f7 ff ff       	jmp    80104dcd <alltraps>

8010561b <vector117>:
.globl vector117
vector117:
  pushl $0
8010561b:	6a 00                	push   $0x0
  pushl $117
8010561d:	6a 75                	push   $0x75
  jmp alltraps
8010561f:	e9 a9 f7 ff ff       	jmp    80104dcd <alltraps>

80105624 <vector118>:
.globl vector118
vector118:
  pushl $0
80105624:	6a 00                	push   $0x0
  pushl $118
80105626:	6a 76                	push   $0x76
  jmp alltraps
80105628:	e9 a0 f7 ff ff       	jmp    80104dcd <alltraps>

8010562d <vector119>:
.globl vector119
vector119:
  pushl $0
8010562d:	6a 00                	push   $0x0
  pushl $119
8010562f:	6a 77                	push   $0x77
  jmp alltraps
80105631:	e9 97 f7 ff ff       	jmp    80104dcd <alltraps>

80105636 <vector120>:
.globl vector120
vector120:
  pushl $0
80105636:	6a 00                	push   $0x0
  pushl $120
80105638:	6a 78                	push   $0x78
  jmp alltraps
8010563a:	e9 8e f7 ff ff       	jmp    80104dcd <alltraps>

8010563f <vector121>:
.globl vector121
vector121:
  pushl $0
8010563f:	6a 00                	push   $0x0
  pushl $121
80105641:	6a 79                	push   $0x79
  jmp alltraps
80105643:	e9 85 f7 ff ff       	jmp    80104dcd <alltraps>

80105648 <vector122>:
.globl vector122
vector122:
  pushl $0
80105648:	6a 00                	push   $0x0
  pushl $122
8010564a:	6a 7a                	push   $0x7a
  jmp alltraps
8010564c:	e9 7c f7 ff ff       	jmp    80104dcd <alltraps>

80105651 <vector123>:
.globl vector123
vector123:
  pushl $0
80105651:	6a 00                	push   $0x0
  pushl $123
80105653:	6a 7b                	push   $0x7b
  jmp alltraps
80105655:	e9 73 f7 ff ff       	jmp    80104dcd <alltraps>

8010565a <vector124>:
.globl vector124
vector124:
  pushl $0
8010565a:	6a 00                	push   $0x0
  pushl $124
8010565c:	6a 7c                	push   $0x7c
  jmp alltraps
8010565e:	e9 6a f7 ff ff       	jmp    80104dcd <alltraps>

80105663 <vector125>:
.globl vector125
vector125:
  pushl $0
80105663:	6a 00                	push   $0x0
  pushl $125
80105665:	6a 7d                	push   $0x7d
  jmp alltraps
80105667:	e9 61 f7 ff ff       	jmp    80104dcd <alltraps>

8010566c <vector126>:
.globl vector126
vector126:
  pushl $0
8010566c:	6a 00                	push   $0x0
  pushl $126
8010566e:	6a 7e                	push   $0x7e
  jmp alltraps
80105670:	e9 58 f7 ff ff       	jmp    80104dcd <alltraps>

80105675 <vector127>:
.globl vector127
vector127:
  pushl $0
80105675:	6a 00                	push   $0x0
  pushl $127
80105677:	6a 7f                	push   $0x7f
  jmp alltraps
80105679:	e9 4f f7 ff ff       	jmp    80104dcd <alltraps>

8010567e <vector128>:
.globl vector128
vector128:
  pushl $0
8010567e:	6a 00                	push   $0x0
  pushl $128
80105680:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80105685:	e9 43 f7 ff ff       	jmp    80104dcd <alltraps>

8010568a <vector129>:
.globl vector129
vector129:
  pushl $0
8010568a:	6a 00                	push   $0x0
  pushl $129
8010568c:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80105691:	e9 37 f7 ff ff       	jmp    80104dcd <alltraps>

80105696 <vector130>:
.globl vector130
vector130:
  pushl $0
80105696:	6a 00                	push   $0x0
  pushl $130
80105698:	68 82 00 00 00       	push   $0x82
  jmp alltraps
8010569d:	e9 2b f7 ff ff       	jmp    80104dcd <alltraps>

801056a2 <vector131>:
.globl vector131
vector131:
  pushl $0
801056a2:	6a 00                	push   $0x0
  pushl $131
801056a4:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801056a9:	e9 1f f7 ff ff       	jmp    80104dcd <alltraps>

801056ae <vector132>:
.globl vector132
vector132:
  pushl $0
801056ae:	6a 00                	push   $0x0
  pushl $132
801056b0:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801056b5:	e9 13 f7 ff ff       	jmp    80104dcd <alltraps>

801056ba <vector133>:
.globl vector133
vector133:
  pushl $0
801056ba:	6a 00                	push   $0x0
  pushl $133
801056bc:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801056c1:	e9 07 f7 ff ff       	jmp    80104dcd <alltraps>

801056c6 <vector134>:
.globl vector134
vector134:
  pushl $0
801056c6:	6a 00                	push   $0x0
  pushl $134
801056c8:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801056cd:	e9 fb f6 ff ff       	jmp    80104dcd <alltraps>

801056d2 <vector135>:
.globl vector135
vector135:
  pushl $0
801056d2:	6a 00                	push   $0x0
  pushl $135
801056d4:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801056d9:	e9 ef f6 ff ff       	jmp    80104dcd <alltraps>

801056de <vector136>:
.globl vector136
vector136:
  pushl $0
801056de:	6a 00                	push   $0x0
  pushl $136
801056e0:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801056e5:	e9 e3 f6 ff ff       	jmp    80104dcd <alltraps>

801056ea <vector137>:
.globl vector137
vector137:
  pushl $0
801056ea:	6a 00                	push   $0x0
  pushl $137
801056ec:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801056f1:	e9 d7 f6 ff ff       	jmp    80104dcd <alltraps>

801056f6 <vector138>:
.globl vector138
vector138:
  pushl $0
801056f6:	6a 00                	push   $0x0
  pushl $138
801056f8:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801056fd:	e9 cb f6 ff ff       	jmp    80104dcd <alltraps>

80105702 <vector139>:
.globl vector139
vector139:
  pushl $0
80105702:	6a 00                	push   $0x0
  pushl $139
80105704:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105709:	e9 bf f6 ff ff       	jmp    80104dcd <alltraps>

8010570e <vector140>:
.globl vector140
vector140:
  pushl $0
8010570e:	6a 00                	push   $0x0
  pushl $140
80105710:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105715:	e9 b3 f6 ff ff       	jmp    80104dcd <alltraps>

8010571a <vector141>:
.globl vector141
vector141:
  pushl $0
8010571a:	6a 00                	push   $0x0
  pushl $141
8010571c:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105721:	e9 a7 f6 ff ff       	jmp    80104dcd <alltraps>

80105726 <vector142>:
.globl vector142
vector142:
  pushl $0
80105726:	6a 00                	push   $0x0
  pushl $142
80105728:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
8010572d:	e9 9b f6 ff ff       	jmp    80104dcd <alltraps>

80105732 <vector143>:
.globl vector143
vector143:
  pushl $0
80105732:	6a 00                	push   $0x0
  pushl $143
80105734:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105739:	e9 8f f6 ff ff       	jmp    80104dcd <alltraps>

8010573e <vector144>:
.globl vector144
vector144:
  pushl $0
8010573e:	6a 00                	push   $0x0
  pushl $144
80105740:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105745:	e9 83 f6 ff ff       	jmp    80104dcd <alltraps>

8010574a <vector145>:
.globl vector145
vector145:
  pushl $0
8010574a:	6a 00                	push   $0x0
  pushl $145
8010574c:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105751:	e9 77 f6 ff ff       	jmp    80104dcd <alltraps>

80105756 <vector146>:
.globl vector146
vector146:
  pushl $0
80105756:	6a 00                	push   $0x0
  pushl $146
80105758:	68 92 00 00 00       	push   $0x92
  jmp alltraps
8010575d:	e9 6b f6 ff ff       	jmp    80104dcd <alltraps>

80105762 <vector147>:
.globl vector147
vector147:
  pushl $0
80105762:	6a 00                	push   $0x0
  pushl $147
80105764:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105769:	e9 5f f6 ff ff       	jmp    80104dcd <alltraps>

8010576e <vector148>:
.globl vector148
vector148:
  pushl $0
8010576e:	6a 00                	push   $0x0
  pushl $148
80105770:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105775:	e9 53 f6 ff ff       	jmp    80104dcd <alltraps>

8010577a <vector149>:
.globl vector149
vector149:
  pushl $0
8010577a:	6a 00                	push   $0x0
  pushl $149
8010577c:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80105781:	e9 47 f6 ff ff       	jmp    80104dcd <alltraps>

80105786 <vector150>:
.globl vector150
vector150:
  pushl $0
80105786:	6a 00                	push   $0x0
  pushl $150
80105788:	68 96 00 00 00       	push   $0x96
  jmp alltraps
8010578d:	e9 3b f6 ff ff       	jmp    80104dcd <alltraps>

80105792 <vector151>:
.globl vector151
vector151:
  pushl $0
80105792:	6a 00                	push   $0x0
  pushl $151
80105794:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80105799:	e9 2f f6 ff ff       	jmp    80104dcd <alltraps>

8010579e <vector152>:
.globl vector152
vector152:
  pushl $0
8010579e:	6a 00                	push   $0x0
  pushl $152
801057a0:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801057a5:	e9 23 f6 ff ff       	jmp    80104dcd <alltraps>

801057aa <vector153>:
.globl vector153
vector153:
  pushl $0
801057aa:	6a 00                	push   $0x0
  pushl $153
801057ac:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801057b1:	e9 17 f6 ff ff       	jmp    80104dcd <alltraps>

801057b6 <vector154>:
.globl vector154
vector154:
  pushl $0
801057b6:	6a 00                	push   $0x0
  pushl $154
801057b8:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801057bd:	e9 0b f6 ff ff       	jmp    80104dcd <alltraps>

801057c2 <vector155>:
.globl vector155
vector155:
  pushl $0
801057c2:	6a 00                	push   $0x0
  pushl $155
801057c4:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801057c9:	e9 ff f5 ff ff       	jmp    80104dcd <alltraps>

801057ce <vector156>:
.globl vector156
vector156:
  pushl $0
801057ce:	6a 00                	push   $0x0
  pushl $156
801057d0:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801057d5:	e9 f3 f5 ff ff       	jmp    80104dcd <alltraps>

801057da <vector157>:
.globl vector157
vector157:
  pushl $0
801057da:	6a 00                	push   $0x0
  pushl $157
801057dc:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801057e1:	e9 e7 f5 ff ff       	jmp    80104dcd <alltraps>

801057e6 <vector158>:
.globl vector158
vector158:
  pushl $0
801057e6:	6a 00                	push   $0x0
  pushl $158
801057e8:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801057ed:	e9 db f5 ff ff       	jmp    80104dcd <alltraps>

801057f2 <vector159>:
.globl vector159
vector159:
  pushl $0
801057f2:	6a 00                	push   $0x0
  pushl $159
801057f4:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801057f9:	e9 cf f5 ff ff       	jmp    80104dcd <alltraps>

801057fe <vector160>:
.globl vector160
vector160:
  pushl $0
801057fe:	6a 00                	push   $0x0
  pushl $160
80105800:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105805:	e9 c3 f5 ff ff       	jmp    80104dcd <alltraps>

8010580a <vector161>:
.globl vector161
vector161:
  pushl $0
8010580a:	6a 00                	push   $0x0
  pushl $161
8010580c:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105811:	e9 b7 f5 ff ff       	jmp    80104dcd <alltraps>

80105816 <vector162>:
.globl vector162
vector162:
  pushl $0
80105816:	6a 00                	push   $0x0
  pushl $162
80105818:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
8010581d:	e9 ab f5 ff ff       	jmp    80104dcd <alltraps>

80105822 <vector163>:
.globl vector163
vector163:
  pushl $0
80105822:	6a 00                	push   $0x0
  pushl $163
80105824:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105829:	e9 9f f5 ff ff       	jmp    80104dcd <alltraps>

8010582e <vector164>:
.globl vector164
vector164:
  pushl $0
8010582e:	6a 00                	push   $0x0
  pushl $164
80105830:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105835:	e9 93 f5 ff ff       	jmp    80104dcd <alltraps>

8010583a <vector165>:
.globl vector165
vector165:
  pushl $0
8010583a:	6a 00                	push   $0x0
  pushl $165
8010583c:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105841:	e9 87 f5 ff ff       	jmp    80104dcd <alltraps>

80105846 <vector166>:
.globl vector166
vector166:
  pushl $0
80105846:	6a 00                	push   $0x0
  pushl $166
80105848:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
8010584d:	e9 7b f5 ff ff       	jmp    80104dcd <alltraps>

80105852 <vector167>:
.globl vector167
vector167:
  pushl $0
80105852:	6a 00                	push   $0x0
  pushl $167
80105854:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105859:	e9 6f f5 ff ff       	jmp    80104dcd <alltraps>

8010585e <vector168>:
.globl vector168
vector168:
  pushl $0
8010585e:	6a 00                	push   $0x0
  pushl $168
80105860:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105865:	e9 63 f5 ff ff       	jmp    80104dcd <alltraps>

8010586a <vector169>:
.globl vector169
vector169:
  pushl $0
8010586a:	6a 00                	push   $0x0
  pushl $169
8010586c:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105871:	e9 57 f5 ff ff       	jmp    80104dcd <alltraps>

80105876 <vector170>:
.globl vector170
vector170:
  pushl $0
80105876:	6a 00                	push   $0x0
  pushl $170
80105878:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
8010587d:	e9 4b f5 ff ff       	jmp    80104dcd <alltraps>

80105882 <vector171>:
.globl vector171
vector171:
  pushl $0
80105882:	6a 00                	push   $0x0
  pushl $171
80105884:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80105889:	e9 3f f5 ff ff       	jmp    80104dcd <alltraps>

8010588e <vector172>:
.globl vector172
vector172:
  pushl $0
8010588e:	6a 00                	push   $0x0
  pushl $172
80105890:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80105895:	e9 33 f5 ff ff       	jmp    80104dcd <alltraps>

8010589a <vector173>:
.globl vector173
vector173:
  pushl $0
8010589a:	6a 00                	push   $0x0
  pushl $173
8010589c:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801058a1:	e9 27 f5 ff ff       	jmp    80104dcd <alltraps>

801058a6 <vector174>:
.globl vector174
vector174:
  pushl $0
801058a6:	6a 00                	push   $0x0
  pushl $174
801058a8:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801058ad:	e9 1b f5 ff ff       	jmp    80104dcd <alltraps>

801058b2 <vector175>:
.globl vector175
vector175:
  pushl $0
801058b2:	6a 00                	push   $0x0
  pushl $175
801058b4:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801058b9:	e9 0f f5 ff ff       	jmp    80104dcd <alltraps>

801058be <vector176>:
.globl vector176
vector176:
  pushl $0
801058be:	6a 00                	push   $0x0
  pushl $176
801058c0:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801058c5:	e9 03 f5 ff ff       	jmp    80104dcd <alltraps>

801058ca <vector177>:
.globl vector177
vector177:
  pushl $0
801058ca:	6a 00                	push   $0x0
  pushl $177
801058cc:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801058d1:	e9 f7 f4 ff ff       	jmp    80104dcd <alltraps>

801058d6 <vector178>:
.globl vector178
vector178:
  pushl $0
801058d6:	6a 00                	push   $0x0
  pushl $178
801058d8:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801058dd:	e9 eb f4 ff ff       	jmp    80104dcd <alltraps>

801058e2 <vector179>:
.globl vector179
vector179:
  pushl $0
801058e2:	6a 00                	push   $0x0
  pushl $179
801058e4:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801058e9:	e9 df f4 ff ff       	jmp    80104dcd <alltraps>

801058ee <vector180>:
.globl vector180
vector180:
  pushl $0
801058ee:	6a 00                	push   $0x0
  pushl $180
801058f0:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801058f5:	e9 d3 f4 ff ff       	jmp    80104dcd <alltraps>

801058fa <vector181>:
.globl vector181
vector181:
  pushl $0
801058fa:	6a 00                	push   $0x0
  pushl $181
801058fc:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105901:	e9 c7 f4 ff ff       	jmp    80104dcd <alltraps>

80105906 <vector182>:
.globl vector182
vector182:
  pushl $0
80105906:	6a 00                	push   $0x0
  pushl $182
80105908:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
8010590d:	e9 bb f4 ff ff       	jmp    80104dcd <alltraps>

80105912 <vector183>:
.globl vector183
vector183:
  pushl $0
80105912:	6a 00                	push   $0x0
  pushl $183
80105914:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105919:	e9 af f4 ff ff       	jmp    80104dcd <alltraps>

8010591e <vector184>:
.globl vector184
vector184:
  pushl $0
8010591e:	6a 00                	push   $0x0
  pushl $184
80105920:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105925:	e9 a3 f4 ff ff       	jmp    80104dcd <alltraps>

8010592a <vector185>:
.globl vector185
vector185:
  pushl $0
8010592a:	6a 00                	push   $0x0
  pushl $185
8010592c:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105931:	e9 97 f4 ff ff       	jmp    80104dcd <alltraps>

80105936 <vector186>:
.globl vector186
vector186:
  pushl $0
80105936:	6a 00                	push   $0x0
  pushl $186
80105938:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
8010593d:	e9 8b f4 ff ff       	jmp    80104dcd <alltraps>

80105942 <vector187>:
.globl vector187
vector187:
  pushl $0
80105942:	6a 00                	push   $0x0
  pushl $187
80105944:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105949:	e9 7f f4 ff ff       	jmp    80104dcd <alltraps>

8010594e <vector188>:
.globl vector188
vector188:
  pushl $0
8010594e:	6a 00                	push   $0x0
  pushl $188
80105950:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105955:	e9 73 f4 ff ff       	jmp    80104dcd <alltraps>

8010595a <vector189>:
.globl vector189
vector189:
  pushl $0
8010595a:	6a 00                	push   $0x0
  pushl $189
8010595c:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105961:	e9 67 f4 ff ff       	jmp    80104dcd <alltraps>

80105966 <vector190>:
.globl vector190
vector190:
  pushl $0
80105966:	6a 00                	push   $0x0
  pushl $190
80105968:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
8010596d:	e9 5b f4 ff ff       	jmp    80104dcd <alltraps>

80105972 <vector191>:
.globl vector191
vector191:
  pushl $0
80105972:	6a 00                	push   $0x0
  pushl $191
80105974:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105979:	e9 4f f4 ff ff       	jmp    80104dcd <alltraps>

8010597e <vector192>:
.globl vector192
vector192:
  pushl $0
8010597e:	6a 00                	push   $0x0
  pushl $192
80105980:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105985:	e9 43 f4 ff ff       	jmp    80104dcd <alltraps>

8010598a <vector193>:
.globl vector193
vector193:
  pushl $0
8010598a:	6a 00                	push   $0x0
  pushl $193
8010598c:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105991:	e9 37 f4 ff ff       	jmp    80104dcd <alltraps>

80105996 <vector194>:
.globl vector194
vector194:
  pushl $0
80105996:	6a 00                	push   $0x0
  pushl $194
80105998:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
8010599d:	e9 2b f4 ff ff       	jmp    80104dcd <alltraps>

801059a2 <vector195>:
.globl vector195
vector195:
  pushl $0
801059a2:	6a 00                	push   $0x0
  pushl $195
801059a4:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801059a9:	e9 1f f4 ff ff       	jmp    80104dcd <alltraps>

801059ae <vector196>:
.globl vector196
vector196:
  pushl $0
801059ae:	6a 00                	push   $0x0
  pushl $196
801059b0:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801059b5:	e9 13 f4 ff ff       	jmp    80104dcd <alltraps>

801059ba <vector197>:
.globl vector197
vector197:
  pushl $0
801059ba:	6a 00                	push   $0x0
  pushl $197
801059bc:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801059c1:	e9 07 f4 ff ff       	jmp    80104dcd <alltraps>

801059c6 <vector198>:
.globl vector198
vector198:
  pushl $0
801059c6:	6a 00                	push   $0x0
  pushl $198
801059c8:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801059cd:	e9 fb f3 ff ff       	jmp    80104dcd <alltraps>

801059d2 <vector199>:
.globl vector199
vector199:
  pushl $0
801059d2:	6a 00                	push   $0x0
  pushl $199
801059d4:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801059d9:	e9 ef f3 ff ff       	jmp    80104dcd <alltraps>

801059de <vector200>:
.globl vector200
vector200:
  pushl $0
801059de:	6a 00                	push   $0x0
  pushl $200
801059e0:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801059e5:	e9 e3 f3 ff ff       	jmp    80104dcd <alltraps>

801059ea <vector201>:
.globl vector201
vector201:
  pushl $0
801059ea:	6a 00                	push   $0x0
  pushl $201
801059ec:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801059f1:	e9 d7 f3 ff ff       	jmp    80104dcd <alltraps>

801059f6 <vector202>:
.globl vector202
vector202:
  pushl $0
801059f6:	6a 00                	push   $0x0
  pushl $202
801059f8:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801059fd:	e9 cb f3 ff ff       	jmp    80104dcd <alltraps>

80105a02 <vector203>:
.globl vector203
vector203:
  pushl $0
80105a02:	6a 00                	push   $0x0
  pushl $203
80105a04:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105a09:	e9 bf f3 ff ff       	jmp    80104dcd <alltraps>

80105a0e <vector204>:
.globl vector204
vector204:
  pushl $0
80105a0e:	6a 00                	push   $0x0
  pushl $204
80105a10:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105a15:	e9 b3 f3 ff ff       	jmp    80104dcd <alltraps>

80105a1a <vector205>:
.globl vector205
vector205:
  pushl $0
80105a1a:	6a 00                	push   $0x0
  pushl $205
80105a1c:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105a21:	e9 a7 f3 ff ff       	jmp    80104dcd <alltraps>

80105a26 <vector206>:
.globl vector206
vector206:
  pushl $0
80105a26:	6a 00                	push   $0x0
  pushl $206
80105a28:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105a2d:	e9 9b f3 ff ff       	jmp    80104dcd <alltraps>

80105a32 <vector207>:
.globl vector207
vector207:
  pushl $0
80105a32:	6a 00                	push   $0x0
  pushl $207
80105a34:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105a39:	e9 8f f3 ff ff       	jmp    80104dcd <alltraps>

80105a3e <vector208>:
.globl vector208
vector208:
  pushl $0
80105a3e:	6a 00                	push   $0x0
  pushl $208
80105a40:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105a45:	e9 83 f3 ff ff       	jmp    80104dcd <alltraps>

80105a4a <vector209>:
.globl vector209
vector209:
  pushl $0
80105a4a:	6a 00                	push   $0x0
  pushl $209
80105a4c:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105a51:	e9 77 f3 ff ff       	jmp    80104dcd <alltraps>

80105a56 <vector210>:
.globl vector210
vector210:
  pushl $0
80105a56:	6a 00                	push   $0x0
  pushl $210
80105a58:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105a5d:	e9 6b f3 ff ff       	jmp    80104dcd <alltraps>

80105a62 <vector211>:
.globl vector211
vector211:
  pushl $0
80105a62:	6a 00                	push   $0x0
  pushl $211
80105a64:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105a69:	e9 5f f3 ff ff       	jmp    80104dcd <alltraps>

80105a6e <vector212>:
.globl vector212
vector212:
  pushl $0
80105a6e:	6a 00                	push   $0x0
  pushl $212
80105a70:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105a75:	e9 53 f3 ff ff       	jmp    80104dcd <alltraps>

80105a7a <vector213>:
.globl vector213
vector213:
  pushl $0
80105a7a:	6a 00                	push   $0x0
  pushl $213
80105a7c:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105a81:	e9 47 f3 ff ff       	jmp    80104dcd <alltraps>

80105a86 <vector214>:
.globl vector214
vector214:
  pushl $0
80105a86:	6a 00                	push   $0x0
  pushl $214
80105a88:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105a8d:	e9 3b f3 ff ff       	jmp    80104dcd <alltraps>

80105a92 <vector215>:
.globl vector215
vector215:
  pushl $0
80105a92:	6a 00                	push   $0x0
  pushl $215
80105a94:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105a99:	e9 2f f3 ff ff       	jmp    80104dcd <alltraps>

80105a9e <vector216>:
.globl vector216
vector216:
  pushl $0
80105a9e:	6a 00                	push   $0x0
  pushl $216
80105aa0:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105aa5:	e9 23 f3 ff ff       	jmp    80104dcd <alltraps>

80105aaa <vector217>:
.globl vector217
vector217:
  pushl $0
80105aaa:	6a 00                	push   $0x0
  pushl $217
80105aac:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105ab1:	e9 17 f3 ff ff       	jmp    80104dcd <alltraps>

80105ab6 <vector218>:
.globl vector218
vector218:
  pushl $0
80105ab6:	6a 00                	push   $0x0
  pushl $218
80105ab8:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105abd:	e9 0b f3 ff ff       	jmp    80104dcd <alltraps>

80105ac2 <vector219>:
.globl vector219
vector219:
  pushl $0
80105ac2:	6a 00                	push   $0x0
  pushl $219
80105ac4:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105ac9:	e9 ff f2 ff ff       	jmp    80104dcd <alltraps>

80105ace <vector220>:
.globl vector220
vector220:
  pushl $0
80105ace:	6a 00                	push   $0x0
  pushl $220
80105ad0:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105ad5:	e9 f3 f2 ff ff       	jmp    80104dcd <alltraps>

80105ada <vector221>:
.globl vector221
vector221:
  pushl $0
80105ada:	6a 00                	push   $0x0
  pushl $221
80105adc:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105ae1:	e9 e7 f2 ff ff       	jmp    80104dcd <alltraps>

80105ae6 <vector222>:
.globl vector222
vector222:
  pushl $0
80105ae6:	6a 00                	push   $0x0
  pushl $222
80105ae8:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105aed:	e9 db f2 ff ff       	jmp    80104dcd <alltraps>

80105af2 <vector223>:
.globl vector223
vector223:
  pushl $0
80105af2:	6a 00                	push   $0x0
  pushl $223
80105af4:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105af9:	e9 cf f2 ff ff       	jmp    80104dcd <alltraps>

80105afe <vector224>:
.globl vector224
vector224:
  pushl $0
80105afe:	6a 00                	push   $0x0
  pushl $224
80105b00:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105b05:	e9 c3 f2 ff ff       	jmp    80104dcd <alltraps>

80105b0a <vector225>:
.globl vector225
vector225:
  pushl $0
80105b0a:	6a 00                	push   $0x0
  pushl $225
80105b0c:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105b11:	e9 b7 f2 ff ff       	jmp    80104dcd <alltraps>

80105b16 <vector226>:
.globl vector226
vector226:
  pushl $0
80105b16:	6a 00                	push   $0x0
  pushl $226
80105b18:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105b1d:	e9 ab f2 ff ff       	jmp    80104dcd <alltraps>

80105b22 <vector227>:
.globl vector227
vector227:
  pushl $0
80105b22:	6a 00                	push   $0x0
  pushl $227
80105b24:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105b29:	e9 9f f2 ff ff       	jmp    80104dcd <alltraps>

80105b2e <vector228>:
.globl vector228
vector228:
  pushl $0
80105b2e:	6a 00                	push   $0x0
  pushl $228
80105b30:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105b35:	e9 93 f2 ff ff       	jmp    80104dcd <alltraps>

80105b3a <vector229>:
.globl vector229
vector229:
  pushl $0
80105b3a:	6a 00                	push   $0x0
  pushl $229
80105b3c:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105b41:	e9 87 f2 ff ff       	jmp    80104dcd <alltraps>

80105b46 <vector230>:
.globl vector230
vector230:
  pushl $0
80105b46:	6a 00                	push   $0x0
  pushl $230
80105b48:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105b4d:	e9 7b f2 ff ff       	jmp    80104dcd <alltraps>

80105b52 <vector231>:
.globl vector231
vector231:
  pushl $0
80105b52:	6a 00                	push   $0x0
  pushl $231
80105b54:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105b59:	e9 6f f2 ff ff       	jmp    80104dcd <alltraps>

80105b5e <vector232>:
.globl vector232
vector232:
  pushl $0
80105b5e:	6a 00                	push   $0x0
  pushl $232
80105b60:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105b65:	e9 63 f2 ff ff       	jmp    80104dcd <alltraps>

80105b6a <vector233>:
.globl vector233
vector233:
  pushl $0
80105b6a:	6a 00                	push   $0x0
  pushl $233
80105b6c:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105b71:	e9 57 f2 ff ff       	jmp    80104dcd <alltraps>

80105b76 <vector234>:
.globl vector234
vector234:
  pushl $0
80105b76:	6a 00                	push   $0x0
  pushl $234
80105b78:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105b7d:	e9 4b f2 ff ff       	jmp    80104dcd <alltraps>

80105b82 <vector235>:
.globl vector235
vector235:
  pushl $0
80105b82:	6a 00                	push   $0x0
  pushl $235
80105b84:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105b89:	e9 3f f2 ff ff       	jmp    80104dcd <alltraps>

80105b8e <vector236>:
.globl vector236
vector236:
  pushl $0
80105b8e:	6a 00                	push   $0x0
  pushl $236
80105b90:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105b95:	e9 33 f2 ff ff       	jmp    80104dcd <alltraps>

80105b9a <vector237>:
.globl vector237
vector237:
  pushl $0
80105b9a:	6a 00                	push   $0x0
  pushl $237
80105b9c:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105ba1:	e9 27 f2 ff ff       	jmp    80104dcd <alltraps>

80105ba6 <vector238>:
.globl vector238
vector238:
  pushl $0
80105ba6:	6a 00                	push   $0x0
  pushl $238
80105ba8:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105bad:	e9 1b f2 ff ff       	jmp    80104dcd <alltraps>

80105bb2 <vector239>:
.globl vector239
vector239:
  pushl $0
80105bb2:	6a 00                	push   $0x0
  pushl $239
80105bb4:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105bb9:	e9 0f f2 ff ff       	jmp    80104dcd <alltraps>

80105bbe <vector240>:
.globl vector240
vector240:
  pushl $0
80105bbe:	6a 00                	push   $0x0
  pushl $240
80105bc0:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105bc5:	e9 03 f2 ff ff       	jmp    80104dcd <alltraps>

80105bca <vector241>:
.globl vector241
vector241:
  pushl $0
80105bca:	6a 00                	push   $0x0
  pushl $241
80105bcc:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105bd1:	e9 f7 f1 ff ff       	jmp    80104dcd <alltraps>

80105bd6 <vector242>:
.globl vector242
vector242:
  pushl $0
80105bd6:	6a 00                	push   $0x0
  pushl $242
80105bd8:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105bdd:	e9 eb f1 ff ff       	jmp    80104dcd <alltraps>

80105be2 <vector243>:
.globl vector243
vector243:
  pushl $0
80105be2:	6a 00                	push   $0x0
  pushl $243
80105be4:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105be9:	e9 df f1 ff ff       	jmp    80104dcd <alltraps>

80105bee <vector244>:
.globl vector244
vector244:
  pushl $0
80105bee:	6a 00                	push   $0x0
  pushl $244
80105bf0:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105bf5:	e9 d3 f1 ff ff       	jmp    80104dcd <alltraps>

80105bfa <vector245>:
.globl vector245
vector245:
  pushl $0
80105bfa:	6a 00                	push   $0x0
  pushl $245
80105bfc:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105c01:	e9 c7 f1 ff ff       	jmp    80104dcd <alltraps>

80105c06 <vector246>:
.globl vector246
vector246:
  pushl $0
80105c06:	6a 00                	push   $0x0
  pushl $246
80105c08:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105c0d:	e9 bb f1 ff ff       	jmp    80104dcd <alltraps>

80105c12 <vector247>:
.globl vector247
vector247:
  pushl $0
80105c12:	6a 00                	push   $0x0
  pushl $247
80105c14:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105c19:	e9 af f1 ff ff       	jmp    80104dcd <alltraps>

80105c1e <vector248>:
.globl vector248
vector248:
  pushl $0
80105c1e:	6a 00                	push   $0x0
  pushl $248
80105c20:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105c25:	e9 a3 f1 ff ff       	jmp    80104dcd <alltraps>

80105c2a <vector249>:
.globl vector249
vector249:
  pushl $0
80105c2a:	6a 00                	push   $0x0
  pushl $249
80105c2c:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105c31:	e9 97 f1 ff ff       	jmp    80104dcd <alltraps>

80105c36 <vector250>:
.globl vector250
vector250:
  pushl $0
80105c36:	6a 00                	push   $0x0
  pushl $250
80105c38:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105c3d:	e9 8b f1 ff ff       	jmp    80104dcd <alltraps>

80105c42 <vector251>:
.globl vector251
vector251:
  pushl $0
80105c42:	6a 00                	push   $0x0
  pushl $251
80105c44:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105c49:	e9 7f f1 ff ff       	jmp    80104dcd <alltraps>

80105c4e <vector252>:
.globl vector252
vector252:
  pushl $0
80105c4e:	6a 00                	push   $0x0
  pushl $252
80105c50:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105c55:	e9 73 f1 ff ff       	jmp    80104dcd <alltraps>

80105c5a <vector253>:
.globl vector253
vector253:
  pushl $0
80105c5a:	6a 00                	push   $0x0
  pushl $253
80105c5c:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105c61:	e9 67 f1 ff ff       	jmp    80104dcd <alltraps>

80105c66 <vector254>:
.globl vector254
vector254:
  pushl $0
80105c66:	6a 00                	push   $0x0
  pushl $254
80105c68:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105c6d:	e9 5b f1 ff ff       	jmp    80104dcd <alltraps>

80105c72 <vector255>:
.globl vector255
vector255:
  pushl $0
80105c72:	6a 00                	push   $0x0
  pushl $255
80105c74:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105c79:	e9 4f f1 ff ff       	jmp    80104dcd <alltraps>
80105c7e:	66 90                	xchg   %ax,%ax

80105c80 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	57                   	push   %edi
80105c84:	56                   	push   %esi
80105c85:	53                   	push   %ebx
80105c86:	83 ec 1c             	sub    $0x1c,%esp
80105c89:	89 d7                	mov    %edx,%edi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105c8b:	89 d3                	mov    %edx,%ebx
80105c8d:	c1 eb 16             	shr    $0x16,%ebx
80105c90:	8d 34 98             	lea    (%eax,%ebx,4),%esi
  if(*pde & PTE_P){
80105c93:	8b 1e                	mov    (%esi),%ebx
80105c95:	f6 c3 01             	test   $0x1,%bl
80105c98:	74 22                	je     80105cbc <walkpgdir+0x3c>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105c9a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80105ca0:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105ca6:	89 fa                	mov    %edi,%edx
80105ca8:	c1 ea 0a             	shr    $0xa,%edx
80105cab:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80105cb1:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80105cb4:	83 c4 1c             	add    $0x1c,%esp
80105cb7:	5b                   	pop    %ebx
80105cb8:	5e                   	pop    %esi
80105cb9:	5f                   	pop    %edi
80105cba:	5d                   	pop    %ebp
80105cbb:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105cbc:	85 c9                	test   %ecx,%ecx
80105cbe:	74 30                	je     80105cf0 <walkpgdir+0x70>
80105cc0:	e8 27 c5 ff ff       	call   801021ec <kalloc>
80105cc5:	89 c3                	mov    %eax,%ebx
80105cc7:	85 c0                	test   %eax,%eax
80105cc9:	74 25                	je     80105cf0 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80105ccb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80105cd2:	00 
80105cd3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105cda:	00 
80105cdb:	89 04 24             	mov    %eax,(%esp)
80105cde:	e8 b1 e0 ff ff       	call   80103d94 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105ce3:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80105ce9:	83 c8 07             	or     $0x7,%eax
80105cec:	89 06                	mov    %eax,(%esi)
80105cee:	eb b6                	jmp    80105ca6 <walkpgdir+0x26>
      return 0;
80105cf0:	31 c0                	xor    %eax,%eax
}
80105cf2:	83 c4 1c             	add    $0x1c,%esp
80105cf5:	5b                   	pop    %ebx
80105cf6:	5e                   	pop    %esi
80105cf7:	5f                   	pop    %edi
80105cf8:	5d                   	pop    %ebp
80105cf9:	c3                   	ret    
80105cfa:	66 90                	xchg   %ax,%ax

80105cfc <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80105cfc:	55                   	push   %ebp
80105cfd:	89 e5                	mov    %esp,%ebp
80105cff:	57                   	push   %edi
80105d00:	56                   	push   %esi
80105d01:	53                   	push   %ebx
80105d02:	83 ec 2c             	sub    $0x2c,%esp
80105d05:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105d08:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80105d0b:	89 d3                	mov    %edx,%ebx
80105d0d:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105d13:	8d 4c 0a ff          	lea    -0x1(%edx,%ecx,1),%ecx
80105d17:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80105d1a:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
80105d21:	29 df                	sub    %ebx,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80105d23:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
80105d27:	eb 18                	jmp    80105d41 <mappages+0x45>
80105d29:	8d 76 00             	lea    0x0(%esi),%esi
    if(*pte & PTE_P)
80105d2c:	f6 00 01             	testb  $0x1,(%eax)
80105d2f:	75 3d                	jne    80105d6e <mappages+0x72>
    *pte = pa | perm | PTE_P;
80105d31:	0b 75 0c             	or     0xc(%ebp),%esi
80105d34:	89 30                	mov    %esi,(%eax)
    if(a == last)
80105d36:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80105d39:	74 29                	je     80105d64 <mappages+0x68>
      break;
    a += PGSIZE;
80105d3b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
80105d41:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105d44:	b9 01 00 00 00       	mov    $0x1,%ecx
80105d49:	89 da                	mov    %ebx,%edx
80105d4b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105d4e:	e8 2d ff ff ff       	call   80105c80 <walkpgdir>
80105d53:	85 c0                	test   %eax,%eax
80105d55:	75 d5                	jne    80105d2c <mappages+0x30>
      return -1;
80105d57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    pa += PGSIZE;
  }
  return 0;
}
80105d5c:	83 c4 2c             	add    $0x2c,%esp
80105d5f:	5b                   	pop    %ebx
80105d60:	5e                   	pop    %esi
80105d61:	5f                   	pop    %edi
80105d62:	5d                   	pop    %ebp
80105d63:	c3                   	ret    
  return 0;
80105d64:	31 c0                	xor    %eax,%eax
}
80105d66:	83 c4 2c             	add    $0x2c,%esp
80105d69:	5b                   	pop    %ebx
80105d6a:	5e                   	pop    %esi
80105d6b:	5f                   	pop    %edi
80105d6c:	5d                   	pop    %ebp
80105d6d:	c3                   	ret    
      panic("remap");
80105d6e:	c7 04 24 dc 74 10 80 	movl   $0x801074dc,(%esp)
80105d75:	e8 96 a5 ff ff       	call   80100310 <panic>
80105d7a:	66 90                	xchg   %ax,%ax

80105d7c <seginit>:
{
80105d7c:	55                   	push   %ebp
80105d7d:	89 e5                	mov    %esp,%ebp
80105d7f:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80105d82:	e8 5d d5 ff ff       	call   801032e4 <cpuid>
80105d87:	8d 14 80             	lea    (%eax,%eax,4),%edx
80105d8a:	8d 04 50             	lea    (%eax,%edx,2),%eax
80105d8d:	c1 e0 04             	shl    $0x4,%eax
80105d90:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80105d95:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80105d9b:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80105da1:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80105da5:	c6 40 7d 9a          	movb   $0x9a,0x7d(%eax)
80105da9:	c6 40 7e cf          	movb   $0xcf,0x7e(%eax)
80105dad:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80105db1:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80105db8:	ff ff 
80105dba:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80105dc1:	00 00 
80105dc3:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80105dca:	c6 80 85 00 00 00 92 	movb   $0x92,0x85(%eax)
80105dd1:	c6 80 86 00 00 00 cf 	movb   $0xcf,0x86(%eax)
80105dd8:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80105ddf:	66 c7 80 88 00 00 00 	movw   $0xffff,0x88(%eax)
80105de6:	ff ff 
80105de8:	66 c7 80 8a 00 00 00 	movw   $0x0,0x8a(%eax)
80105def:	00 00 
80105df1:	c6 80 8c 00 00 00 00 	movb   $0x0,0x8c(%eax)
80105df8:	c6 80 8d 00 00 00 fa 	movb   $0xfa,0x8d(%eax)
80105dff:	c6 80 8e 00 00 00 cf 	movb   $0xcf,0x8e(%eax)
80105e06:	c6 80 8f 00 00 00 00 	movb   $0x0,0x8f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80105e0d:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80105e14:	ff ff 
80105e16:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80105e1d:	00 00 
80105e1f:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80105e26:	c6 80 95 00 00 00 f2 	movb   $0xf2,0x95(%eax)
80105e2d:	c6 80 96 00 00 00 cf 	movb   $0xcf,0x96(%eax)
80105e34:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80105e3b:	83 c0 70             	add    $0x70,%eax
  pd[0] = size-1;
80105e3e:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80105e44:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80105e48:	c1 e8 10             	shr    $0x10,%eax
80105e4b:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80105e4f:	8d 45 f2             	lea    -0xe(%ebp),%eax
80105e52:	0f 01 10             	lgdtl  (%eax)
}
80105e55:	c9                   	leave  
80105e56:	c3                   	ret    
80105e57:	90                   	nop

80105e58 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80105e58:	55                   	push   %ebp
80105e59:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80105e5b:	a1 a4 57 11 80       	mov    0x801157a4,%eax
80105e60:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105e65:	0f 22 d8             	mov    %eax,%cr3
}
80105e68:	5d                   	pop    %ebp
80105e69:	c3                   	ret    
80105e6a:	66 90                	xchg   %ax,%ax

80105e6c <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80105e6c:	55                   	push   %ebp
80105e6d:	89 e5                	mov    %esp,%ebp
80105e6f:	57                   	push   %edi
80105e70:	56                   	push   %esi
80105e71:	53                   	push   %ebx
80105e72:	83 ec 2c             	sub    $0x2c,%esp
80105e75:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80105e78:	85 f6                	test   %esi,%esi
80105e7a:	0f 84 c4 00 00 00    	je     80105f44 <switchuvm+0xd8>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80105e80:	8b 56 08             	mov    0x8(%esi),%edx
80105e83:	85 d2                	test   %edx,%edx
80105e85:	0f 84 d1 00 00 00    	je     80105f5c <switchuvm+0xf0>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
80105e8b:	8b 46 04             	mov    0x4(%esi),%eax
80105e8e:	85 c0                	test   %eax,%eax
80105e90:	0f 84 ba 00 00 00    	je     80105f50 <switchuvm+0xe4>
    panic("switchuvm: no pgdir");

  pushcli();
80105e96:	e8 bd dd ff ff       	call   80103c58 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80105e9b:	e8 d0 d3 ff ff       	call   80103270 <mycpu>
80105ea0:	89 c3                	mov    %eax,%ebx
80105ea2:	e8 c9 d3 ff ff       	call   80103270 <mycpu>
80105ea7:	89 c7                	mov    %eax,%edi
80105ea9:	e8 c2 d3 ff ff       	call   80103270 <mycpu>
80105eae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105eb1:	e8 ba d3 ff ff       	call   80103270 <mycpu>
80105eb6:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
80105ebd:	67 00 
80105ebf:	83 c7 08             	add    $0x8,%edi
80105ec2:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80105ec9:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105ecc:	83 c1 08             	add    $0x8,%ecx
80105ecf:	c1 e9 10             	shr    $0x10,%ecx
80105ed2:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80105ed8:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80105edf:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80105ee6:	83 c0 08             	add    $0x8,%eax
80105ee9:	c1 e8 18             	shr    $0x18,%eax
80105eec:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80105ef2:	e8 79 d3 ff ff       	call   80103270 <mycpu>
80105ef7:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80105efe:	e8 6d d3 ff ff       	call   80103270 <mycpu>
80105f03:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80105f09:	e8 62 d3 ff ff       	call   80103270 <mycpu>
80105f0e:	8b 4e 08             	mov    0x8(%esi),%ecx
80105f11:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80105f17:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80105f1a:	e8 51 d3 ff ff       	call   80103270 <mycpu>
80105f1f:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80105f25:	b8 28 00 00 00       	mov    $0x28,%eax
80105f2a:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80105f2d:	8b 46 04             	mov    0x4(%esi),%eax
80105f30:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105f35:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80105f38:	83 c4 2c             	add    $0x2c,%esp
80105f3b:	5b                   	pop    %ebx
80105f3c:	5e                   	pop    %esi
80105f3d:	5f                   	pop    %edi
80105f3e:	5d                   	pop    %ebp
  popcli();
80105f3f:	e9 b0 dd ff ff       	jmp    80103cf4 <popcli>
    panic("switchuvm: no process");
80105f44:	c7 04 24 e2 74 10 80 	movl   $0x801074e2,(%esp)
80105f4b:	e8 c0 a3 ff ff       	call   80100310 <panic>
    panic("switchuvm: no pgdir");
80105f50:	c7 04 24 0d 75 10 80 	movl   $0x8010750d,(%esp)
80105f57:	e8 b4 a3 ff ff       	call   80100310 <panic>
    panic("switchuvm: no kstack");
80105f5c:	c7 04 24 f8 74 10 80 	movl   $0x801074f8,(%esp)
80105f63:	e8 a8 a3 ff ff       	call   80100310 <panic>

80105f68 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80105f68:	55                   	push   %ebp
80105f69:	89 e5                	mov    %esp,%ebp
80105f6b:	57                   	push   %edi
80105f6c:	56                   	push   %esi
80105f6d:	53                   	push   %ebx
80105f6e:	83 ec 2c             	sub    $0x2c,%esp
80105f71:	8b 45 08             	mov    0x8(%ebp),%eax
80105f74:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105f77:	8b 7d 0c             	mov    0xc(%ebp),%edi
80105f7a:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
80105f7d:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80105f83:	77 54                	ja     80105fd9 <inituvm+0x71>
    panic("inituvm: more than a page");
  mem = kalloc();
80105f85:	e8 62 c2 ff ff       	call   801021ec <kalloc>
80105f8a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80105f8c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80105f93:	00 
80105f94:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105f9b:	00 
80105f9c:	89 04 24             	mov    %eax,(%esp)
80105f9f:	e8 f0 dd ff ff       	call   80103d94 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80105fa4:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80105fab:	00 
80105fac:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80105fb2:	89 04 24             	mov    %eax,(%esp)
80105fb5:	b9 00 10 00 00       	mov    $0x1000,%ecx
80105fba:	31 d2                	xor    %edx,%edx
80105fbc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105fbf:	e8 38 fd ff ff       	call   80105cfc <mappages>
  memmove(mem, init, sz);
80105fc4:	89 75 10             	mov    %esi,0x10(%ebp)
80105fc7:	89 7d 0c             	mov    %edi,0xc(%ebp)
80105fca:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80105fcd:	83 c4 2c             	add    $0x2c,%esp
80105fd0:	5b                   	pop    %ebx
80105fd1:	5e                   	pop    %esi
80105fd2:	5f                   	pop    %edi
80105fd3:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80105fd4:	e9 4f de ff ff       	jmp    80103e28 <memmove>
    panic("inituvm: more than a page");
80105fd9:	c7 04 24 21 75 10 80 	movl   $0x80107521,(%esp)
80105fe0:	e8 2b a3 ff ff       	call   80100310 <panic>
80105fe5:	8d 76 00             	lea    0x0(%esi),%esi

80105fe8 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80105fe8:	55                   	push   %ebp
80105fe9:	89 e5                	mov    %esp,%ebp
80105feb:	57                   	push   %edi
80105fec:	56                   	push   %esi
80105fed:	53                   	push   %ebx
80105fee:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80105ff1:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80105ff8:	0f 85 97 00 00 00    	jne    80106095 <loaduvm+0xad>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80105ffe:	8b 4d 18             	mov    0x18(%ebp),%ecx
80106001:	85 c9                	test   %ecx,%ecx
80106003:	74 6b                	je     80106070 <loaduvm+0x88>
80106005:	8b 75 18             	mov    0x18(%ebp),%esi
80106008:	31 db                	xor    %ebx,%ebx
8010600a:	eb 3b                	jmp    80106047 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
8010600c:	bf 00 10 00 00       	mov    $0x1000,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106011:	89 7c 24 0c          	mov    %edi,0xc(%esp)
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
80106015:	8b 4d 14             	mov    0x14(%ebp),%ecx
80106018:	01 d9                	add    %ebx,%ecx
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010601a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010601e:	05 00 00 00 80       	add    $0x80000000,%eax
80106023:	89 44 24 04          	mov    %eax,0x4(%esp)
80106027:	8b 45 10             	mov    0x10(%ebp),%eax
8010602a:	89 04 24             	mov    %eax,(%esp)
8010602d:	e8 ba b7 ff ff       	call   801017ec <readi>
80106032:	39 f8                	cmp    %edi,%eax
80106034:	75 46                	jne    8010607c <loaduvm+0x94>
  for(i = 0; i < sz; i += PGSIZE){
80106036:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010603c:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106042:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106045:	76 29                	jbe    80106070 <loaduvm+0x88>
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
80106047:	8b 55 0c             	mov    0xc(%ebp),%edx
8010604a:	01 da                	add    %ebx,%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010604c:	31 c9                	xor    %ecx,%ecx
8010604e:	8b 45 08             	mov    0x8(%ebp),%eax
80106051:	e8 2a fc ff ff       	call   80105c80 <walkpgdir>
80106056:	85 c0                	test   %eax,%eax
80106058:	74 2f                	je     80106089 <loaduvm+0xa1>
    pa = PTE_ADDR(*pte);
8010605a:	8b 00                	mov    (%eax),%eax
8010605c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106061:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106067:	77 a3                	ja     8010600c <loaduvm+0x24>
80106069:	89 f7                	mov    %esi,%edi
8010606b:	eb a4                	jmp    80106011 <loaduvm+0x29>
8010606d:	8d 76 00             	lea    0x0(%esi),%esi
      return -1;
  }
  return 0;
80106070:	31 c0                	xor    %eax,%eax
}
80106072:	83 c4 1c             	add    $0x1c,%esp
80106075:	5b                   	pop    %ebx
80106076:	5e                   	pop    %esi
80106077:	5f                   	pop    %edi
80106078:	5d                   	pop    %ebp
80106079:	c3                   	ret    
8010607a:	66 90                	xchg   %ax,%ax
      return -1;
8010607c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106081:	83 c4 1c             	add    $0x1c,%esp
80106084:	5b                   	pop    %ebx
80106085:	5e                   	pop    %esi
80106086:	5f                   	pop    %edi
80106087:	5d                   	pop    %ebp
80106088:	c3                   	ret    
      panic("loaduvm: address should exist");
80106089:	c7 04 24 3b 75 10 80 	movl   $0x8010753b,(%esp)
80106090:	e8 7b a2 ff ff       	call   80100310 <panic>
    panic("loaduvm: addr must be page aligned");
80106095:	c7 04 24 dc 75 10 80 	movl   $0x801075dc,(%esp)
8010609c:	e8 6f a2 ff ff       	call   80100310 <panic>
801060a1:	8d 76 00             	lea    0x0(%esi),%esi

801060a4 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801060a4:	55                   	push   %ebp
801060a5:	89 e5                	mov    %esp,%ebp
801060a7:	57                   	push   %edi
801060a8:	56                   	push   %esi
801060a9:	53                   	push   %ebx
801060aa:	83 ec 2c             	sub    $0x2c,%esp
801060ad:	8b 7d 08             	mov    0x8(%ebp),%edi
801060b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801060b3:	39 75 10             	cmp    %esi,0x10(%ebp)
801060b6:	73 7c                	jae    80106134 <deallocuvm+0x90>
    return oldsz;

  a = PGROUNDUP(newsz);
801060b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
801060bb:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
801060c1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801060c7:	39 de                	cmp    %ebx,%esi
801060c9:	77 38                	ja     80106103 <deallocuvm+0x5f>
801060cb:	eb 5b                	jmp    80106128 <deallocuvm+0x84>
801060cd:	8d 76 00             	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
801060d0:	8b 10                	mov    (%eax),%edx
801060d2:	f6 c2 01             	test   $0x1,%dl
801060d5:	74 22                	je     801060f9 <deallocuvm+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
801060d7:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
801060dd:	74 5f                	je     8010613e <deallocuvm+0x9a>
        panic("kfree");
      char *v = P2V(pa);
801060df:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
801060e5:	89 14 24             	mov    %edx,(%esp)
801060e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801060eb:	e8 c0 bf ff ff       	call   801020b0 <kfree>
      *pte = 0;
801060f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801060f3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801060f9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801060ff:	39 de                	cmp    %ebx,%esi
80106101:	76 25                	jbe    80106128 <deallocuvm+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106103:	31 c9                	xor    %ecx,%ecx
80106105:	89 da                	mov    %ebx,%edx
80106107:	89 f8                	mov    %edi,%eax
80106109:	e8 72 fb ff ff       	call   80105c80 <walkpgdir>
    if(!pte)
8010610e:	85 c0                	test   %eax,%eax
80106110:	75 be                	jne    801060d0 <deallocuvm+0x2c>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106112:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106118:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010611e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106124:	39 de                	cmp    %ebx,%esi
80106126:	77 db                	ja     80106103 <deallocuvm+0x5f>
    }
  }
  return newsz;
80106128:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010612b:	83 c4 2c             	add    $0x2c,%esp
8010612e:	5b                   	pop    %ebx
8010612f:	5e                   	pop    %esi
80106130:	5f                   	pop    %edi
80106131:	5d                   	pop    %ebp
80106132:	c3                   	ret    
80106133:	90                   	nop
    return oldsz;
80106134:	89 f0                	mov    %esi,%eax
}
80106136:	83 c4 2c             	add    $0x2c,%esp
80106139:	5b                   	pop    %ebx
8010613a:	5e                   	pop    %esi
8010613b:	5f                   	pop    %edi
8010613c:	5d                   	pop    %ebp
8010613d:	c3                   	ret    
        panic("kfree");
8010613e:	c7 04 24 86 6e 10 80 	movl   $0x80106e86,(%esp)
80106145:	e8 c6 a1 ff ff       	call   80100310 <panic>
8010614a:	66 90                	xchg   %ax,%ax

8010614c <allocuvm>:
{
8010614c:	55                   	push   %ebp
8010614d:	89 e5                	mov    %esp,%ebp
8010614f:	57                   	push   %edi
80106150:	56                   	push   %esi
80106151:	53                   	push   %ebx
80106152:	83 ec 2c             	sub    $0x2c,%esp
  if(newsz >= KERNBASE)
80106155:	8b 7d 10             	mov    0x10(%ebp),%edi
80106158:	85 ff                	test   %edi,%edi
8010615a:	0f 88 c4 00 00 00    	js     80106224 <allocuvm+0xd8>
  if(newsz < oldsz)
80106160:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106163:	0f 82 ab 00 00 00    	jb     80106214 <allocuvm+0xc8>
  a = PGROUNDUP(oldsz);
80106169:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010616c:	81 c3 ff 0f 00 00    	add    $0xfff,%ebx
80106172:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106178:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010617b:	0f 86 96 00 00 00    	jbe    80106217 <allocuvm+0xcb>
80106181:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80106184:	8b 7d 08             	mov    0x8(%ebp),%edi
80106187:	eb 4d                	jmp    801061d6 <allocuvm+0x8a>
80106189:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
8010618c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106193:	00 
80106194:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010619b:	00 
8010619c:	89 04 24             	mov    %eax,(%esp)
8010619f:	e8 f0 db ff ff       	call   80103d94 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801061a4:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
801061ab:	00 
801061ac:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
801061b2:	89 04 24             	mov    %eax,(%esp)
801061b5:	b9 00 10 00 00       	mov    $0x1000,%ecx
801061ba:	89 da                	mov    %ebx,%edx
801061bc:	89 f8                	mov    %edi,%eax
801061be:	e8 39 fb ff ff       	call   80105cfc <mappages>
801061c3:	85 c0                	test   %eax,%eax
801061c5:	78 69                	js     80106230 <allocuvm+0xe4>
  for(; a < newsz; a += PGSIZE){
801061c7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801061cd:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801061d0:	0f 86 96 00 00 00    	jbe    8010626c <allocuvm+0x120>
    mem = kalloc();
801061d6:	e8 11 c0 ff ff       	call   801021ec <kalloc>
801061db:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801061dd:	85 c0                	test   %eax,%eax
801061df:	75 ab                	jne    8010618c <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801061e1:	c7 04 24 59 75 10 80 	movl   $0x80107559,(%esp)
801061e8:	e8 c7 a3 ff ff       	call   801005b4 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801061ed:	8b 45 0c             	mov    0xc(%ebp),%eax
801061f0:	89 44 24 08          	mov    %eax,0x8(%esp)
801061f4:	8b 45 10             	mov    0x10(%ebp),%eax
801061f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801061fb:	8b 45 08             	mov    0x8(%ebp),%eax
801061fe:	89 04 24             	mov    %eax,(%esp)
80106201:	e8 9e fe ff ff       	call   801060a4 <deallocuvm>
      return 0;
80106206:	31 ff                	xor    %edi,%edi
}
80106208:	89 f8                	mov    %edi,%eax
8010620a:	83 c4 2c             	add    $0x2c,%esp
8010620d:	5b                   	pop    %ebx
8010620e:	5e                   	pop    %esi
8010620f:	5f                   	pop    %edi
80106210:	5d                   	pop    %ebp
80106211:	c3                   	ret    
80106212:	66 90                	xchg   %ax,%ax
    return oldsz;
80106214:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
80106217:	89 f8                	mov    %edi,%eax
80106219:	83 c4 2c             	add    $0x2c,%esp
8010621c:	5b                   	pop    %ebx
8010621d:	5e                   	pop    %esi
8010621e:	5f                   	pop    %edi
8010621f:	5d                   	pop    %ebp
80106220:	c3                   	ret    
80106221:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
80106224:	31 ff                	xor    %edi,%edi
}
80106226:	89 f8                	mov    %edi,%eax
80106228:	83 c4 2c             	add    $0x2c,%esp
8010622b:	5b                   	pop    %ebx
8010622c:	5e                   	pop    %esi
8010622d:	5f                   	pop    %edi
8010622e:	5d                   	pop    %ebp
8010622f:	c3                   	ret    
      cprintf("allocuvm out of memory (2)\n");
80106230:	c7 04 24 71 75 10 80 	movl   $0x80107571,(%esp)
80106237:	e8 78 a3 ff ff       	call   801005b4 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
8010623c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010623f:	89 44 24 08          	mov    %eax,0x8(%esp)
80106243:	8b 45 10             	mov    0x10(%ebp),%eax
80106246:	89 44 24 04          	mov    %eax,0x4(%esp)
8010624a:	8b 45 08             	mov    0x8(%ebp),%eax
8010624d:	89 04 24             	mov    %eax,(%esp)
80106250:	e8 4f fe ff ff       	call   801060a4 <deallocuvm>
      kfree(mem);
80106255:	89 34 24             	mov    %esi,(%esp)
80106258:	e8 53 be ff ff       	call   801020b0 <kfree>
      return 0;
8010625d:	31 ff                	xor    %edi,%edi
}
8010625f:	89 f8                	mov    %edi,%eax
80106261:	83 c4 2c             	add    $0x2c,%esp
80106264:	5b                   	pop    %ebx
80106265:	5e                   	pop    %esi
80106266:	5f                   	pop    %edi
80106267:	5d                   	pop    %ebp
80106268:	c3                   	ret    
80106269:	8d 76 00             	lea    0x0(%esi),%esi
8010626c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010626f:	89 f8                	mov    %edi,%eax
80106271:	83 c4 2c             	add    $0x2c,%esp
80106274:	5b                   	pop    %ebx
80106275:	5e                   	pop    %esi
80106276:	5f                   	pop    %edi
80106277:	5d                   	pop    %ebp
80106278:	c3                   	ret    
80106279:	8d 76 00             	lea    0x0(%esi),%esi

8010627c <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
8010627c:	55                   	push   %ebp
8010627d:	89 e5                	mov    %esp,%ebp
8010627f:	56                   	push   %esi
80106280:	53                   	push   %ebx
80106281:	83 ec 10             	sub    $0x10,%esp
80106284:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106287:	85 f6                	test   %esi,%esi
80106289:	74 56                	je     801062e1 <freevm+0x65>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
8010628b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106292:	00 
80106293:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
8010629a:	80 
8010629b:	89 34 24             	mov    %esi,(%esp)
8010629e:	e8 01 fe ff ff       	call   801060a4 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
801062a3:	31 db                	xor    %ebx,%ebx
801062a5:	eb 0a                	jmp    801062b1 <freevm+0x35>
801062a7:	90                   	nop
801062a8:	43                   	inc    %ebx
801062a9:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801062af:	74 22                	je     801062d3 <freevm+0x57>
    if(pgdir[i] & PTE_P){
801062b1:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
801062b4:	a8 01                	test   $0x1,%al
801062b6:	74 f0                	je     801062a8 <freevm+0x2c>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801062b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801062bd:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801062c2:	89 04 24             	mov    %eax,(%esp)
801062c5:	e8 e6 bd ff ff       	call   801020b0 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
801062ca:	43                   	inc    %ebx
801062cb:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
801062d1:	75 de                	jne    801062b1 <freevm+0x35>
    }
  }
  kfree((char*)pgdir);
801062d3:	89 75 08             	mov    %esi,0x8(%ebp)
}
801062d6:	83 c4 10             	add    $0x10,%esp
801062d9:	5b                   	pop    %ebx
801062da:	5e                   	pop    %esi
801062db:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801062dc:	e9 cf bd ff ff       	jmp    801020b0 <kfree>
    panic("freevm: no pgdir");
801062e1:	c7 04 24 8d 75 10 80 	movl   $0x8010758d,(%esp)
801062e8:	e8 23 a0 ff ff       	call   80100310 <panic>
801062ed:	8d 76 00             	lea    0x0(%esi),%esi

801062f0 <setupkvm>:
{
801062f0:	55                   	push   %ebp
801062f1:	89 e5                	mov    %esp,%ebp
801062f3:	56                   	push   %esi
801062f4:	53                   	push   %ebx
801062f5:	83 ec 10             	sub    $0x10,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
801062f8:	e8 ef be ff ff       	call   801021ec <kalloc>
801062fd:	89 c6                	mov    %eax,%esi
801062ff:	85 c0                	test   %eax,%eax
80106301:	74 47                	je     8010634a <setupkvm+0x5a>
  memset(pgdir, 0, PGSIZE);
80106303:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010630a:	00 
8010630b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106312:	00 
80106313:	89 04 24             	mov    %eax,(%esp)
80106316:	e8 79 da ff ff       	call   80103d94 <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010631b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106320:	8b 43 04             	mov    0x4(%ebx),%eax
80106323:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106326:	29 c1                	sub    %eax,%ecx
80106328:	8b 53 0c             	mov    0xc(%ebx),%edx
8010632b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010632f:	89 04 24             	mov    %eax,(%esp)
80106332:	8b 13                	mov    (%ebx),%edx
80106334:	89 f0                	mov    %esi,%eax
80106336:	e8 c1 f9 ff ff       	call   80105cfc <mappages>
8010633b:	85 c0                	test   %eax,%eax
8010633d:	78 15                	js     80106354 <setupkvm+0x64>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010633f:	83 c3 10             	add    $0x10,%ebx
80106342:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106348:	72 d6                	jb     80106320 <setupkvm+0x30>
}
8010634a:	89 f0                	mov    %esi,%eax
8010634c:	83 c4 10             	add    $0x10,%esp
8010634f:	5b                   	pop    %ebx
80106350:	5e                   	pop    %esi
80106351:	5d                   	pop    %ebp
80106352:	c3                   	ret    
80106353:	90                   	nop
      freevm(pgdir);
80106354:	89 34 24             	mov    %esi,(%esp)
80106357:	e8 20 ff ff ff       	call   8010627c <freevm>
      return 0;
8010635c:	31 f6                	xor    %esi,%esi
}
8010635e:	89 f0                	mov    %esi,%eax
80106360:	83 c4 10             	add    $0x10,%esp
80106363:	5b                   	pop    %ebx
80106364:	5e                   	pop    %esi
80106365:	5d                   	pop    %ebp
80106366:	c3                   	ret    
80106367:	90                   	nop

80106368 <kvmalloc>:
{
80106368:	55                   	push   %ebp
80106369:	89 e5                	mov    %esp,%ebp
8010636b:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010636e:	e8 7d ff ff ff       	call   801062f0 <setupkvm>
80106373:	a3 a4 57 11 80       	mov    %eax,0x801157a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106378:	05 00 00 00 80       	add    $0x80000000,%eax
8010637d:	0f 22 d8             	mov    %eax,%cr3
}
80106380:	c9                   	leave  
80106381:	c3                   	ret    
80106382:	66 90                	xchg   %ax,%ax

80106384 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106384:	55                   	push   %ebp
80106385:	89 e5                	mov    %esp,%ebp
80106387:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010638a:	31 c9                	xor    %ecx,%ecx
8010638c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010638f:	8b 45 08             	mov    0x8(%ebp),%eax
80106392:	e8 e9 f8 ff ff       	call   80105c80 <walkpgdir>
  if(pte == 0)
80106397:	85 c0                	test   %eax,%eax
80106399:	74 05                	je     801063a0 <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
8010639b:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010639e:	c9                   	leave  
8010639f:	c3                   	ret    
    panic("clearpteu");
801063a0:	c7 04 24 9e 75 10 80 	movl   $0x8010759e,(%esp)
801063a7:	e8 64 9f ff ff       	call   80100310 <panic>

801063ac <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801063ac:	55                   	push   %ebp
801063ad:	89 e5                	mov    %esp,%ebp
801063af:	57                   	push   %edi
801063b0:	56                   	push   %esi
801063b1:	53                   	push   %ebx
801063b2:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801063b5:	e8 36 ff ff ff       	call   801062f0 <setupkvm>
801063ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
801063bd:	85 c0                	test   %eax,%eax
801063bf:	0f 84 9f 00 00 00    	je     80106464 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801063c5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801063c8:	85 db                	test   %ebx,%ebx
801063ca:	0f 84 94 00 00 00    	je     80106464 <copyuvm+0xb8>
801063d0:	31 db                	xor    %ebx,%ebx
801063d2:	eb 48                	jmp    8010641c <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801063d4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801063db:	00 
801063dc:	81 c7 00 00 00 80    	add    $0x80000000,%edi
801063e2:	89 7c 24 04          	mov    %edi,0x4(%esp)
801063e6:	89 04 24             	mov    %eax,(%esp)
801063e9:	e8 3a da ff ff       	call   80103e28 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0)
801063ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801063f1:	89 44 24 04          	mov    %eax,0x4(%esp)
801063f5:	8d 96 00 00 00 80    	lea    -0x80000000(%esi),%edx
801063fb:	89 14 24             	mov    %edx,(%esp)
801063fe:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106403:	89 da                	mov    %ebx,%edx
80106405:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106408:	e8 ef f8 ff ff       	call   80105cfc <mappages>
8010640d:	85 c0                	test   %eax,%eax
8010640f:	78 41                	js     80106452 <copyuvm+0xa6>
  for(i = 0; i < sz; i += PGSIZE){
80106411:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106417:	39 5d 0c             	cmp    %ebx,0xc(%ebp)
8010641a:	76 48                	jbe    80106464 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010641c:	31 c9                	xor    %ecx,%ecx
8010641e:	89 da                	mov    %ebx,%edx
80106420:	8b 45 08             	mov    0x8(%ebp),%eax
80106423:	e8 58 f8 ff ff       	call   80105c80 <walkpgdir>
80106428:	85 c0                	test   %eax,%eax
8010642a:	74 43                	je     8010646f <copyuvm+0xc3>
    if(!(*pte & PTE_P))
8010642c:	8b 30                	mov    (%eax),%esi
8010642e:	f7 c6 01 00 00 00    	test   $0x1,%esi
80106434:	74 45                	je     8010647b <copyuvm+0xcf>
    pa = PTE_ADDR(*pte);
80106436:	89 f7                	mov    %esi,%edi
80106438:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    flags = PTE_FLAGS(*pte);
8010643e:	81 e6 ff 0f 00 00    	and    $0xfff,%esi
80106444:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80106447:	e8 a0 bd ff ff       	call   801021ec <kalloc>
8010644c:	89 c6                	mov    %eax,%esi
8010644e:	85 c0                	test   %eax,%eax
80106450:	75 82                	jne    801063d4 <copyuvm+0x28>
      goto bad;
  }
  return d;

bad:
  freevm(d);
80106452:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106455:	89 04 24             	mov    %eax,(%esp)
80106458:	e8 1f fe ff ff       	call   8010627c <freevm>
  return 0;
8010645d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
80106464:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106467:	83 c4 2c             	add    $0x2c,%esp
8010646a:	5b                   	pop    %ebx
8010646b:	5e                   	pop    %esi
8010646c:	5f                   	pop    %edi
8010646d:	5d                   	pop    %ebp
8010646e:	c3                   	ret    
      panic("copyuvm: pte should exist");
8010646f:	c7 04 24 a8 75 10 80 	movl   $0x801075a8,(%esp)
80106476:	e8 95 9e ff ff       	call   80100310 <panic>
      panic("copyuvm: page not present");
8010647b:	c7 04 24 c2 75 10 80 	movl   $0x801075c2,(%esp)
80106482:	e8 89 9e ff ff       	call   80100310 <panic>
80106487:	90                   	nop

80106488 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106488:	55                   	push   %ebp
80106489:	89 e5                	mov    %esp,%ebp
8010648b:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010648e:	31 c9                	xor    %ecx,%ecx
80106490:	8b 55 0c             	mov    0xc(%ebp),%edx
80106493:	8b 45 08             	mov    0x8(%ebp),%eax
80106496:	e8 e5 f7 ff ff       	call   80105c80 <walkpgdir>
  if((*pte & PTE_P) == 0)
8010649b:	8b 00                	mov    (%eax),%eax
8010649d:	a8 01                	test   $0x1,%al
8010649f:	74 13                	je     801064b4 <uva2ka+0x2c>
    return 0;
  if((*pte & PTE_U) == 0)
801064a1:	a8 04                	test   $0x4,%al
801064a3:	74 0f                	je     801064b4 <uva2ka+0x2c>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801064a5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801064aa:	05 00 00 00 80       	add    $0x80000000,%eax
}
801064af:	c9                   	leave  
801064b0:	c3                   	ret    
801064b1:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
801064b4:	31 c0                	xor    %eax,%eax
}
801064b6:	c9                   	leave  
801064b7:	c3                   	ret    

801064b8 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801064b8:	55                   	push   %ebp
801064b9:	89 e5                	mov    %esp,%ebp
801064bb:	57                   	push   %edi
801064bc:	56                   	push   %esi
801064bd:	53                   	push   %ebx
801064be:	83 ec 2c             	sub    $0x2c,%esp
801064c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
801064c4:	8b 7d 10             	mov    0x10(%ebp),%edi
801064c7:	8b 45 14             	mov    0x14(%ebp),%eax
801064ca:	85 c0                	test   %eax,%eax
801064cc:	74 6e                	je     8010653c <copyout+0x84>
801064ce:	89 f0                	mov    %esi,%eax
801064d0:	89 fe                	mov    %edi,%esi
801064d2:	89 c7                	mov    %eax,%edi
801064d4:	eb 3d                	jmp    80106513 <copyout+0x5b>
801064d6:	66 90                	xchg   %ax,%ax
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
801064d8:	89 da                	mov    %ebx,%edx
801064da:	29 fa                	sub    %edi,%edx
801064dc:	81 c2 00 10 00 00    	add    $0x1000,%edx
801064e2:	3b 55 14             	cmp    0x14(%ebp),%edx
801064e5:	76 03                	jbe    801064ea <copyout+0x32>
801064e7:	8b 55 14             	mov    0x14(%ebp),%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
801064ea:	89 54 24 08          	mov    %edx,0x8(%esp)
801064ee:	89 74 24 04          	mov    %esi,0x4(%esp)
801064f2:	89 f9                	mov    %edi,%ecx
801064f4:	29 d9                	sub    %ebx,%ecx
801064f6:	01 c8                	add    %ecx,%eax
801064f8:	89 04 24             	mov    %eax,(%esp)
801064fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801064fe:	e8 25 d9 ff ff       	call   80103e28 <memmove>
    len -= n;
    buf += n;
80106503:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106506:	01 d6                	add    %edx,%esi
    va = va0 + PGSIZE;
80106508:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
  while(len > 0){
8010650e:	29 55 14             	sub    %edx,0x14(%ebp)
80106511:	74 29                	je     8010653c <copyout+0x84>
    va0 = (uint)PGROUNDDOWN(va);
80106513:	89 fb                	mov    %edi,%ebx
80106515:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    pa0 = uva2ka(pgdir, (char*)va0);
8010651b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
8010651f:	8b 45 08             	mov    0x8(%ebp),%eax
80106522:	89 04 24             	mov    %eax,(%esp)
80106525:	e8 5e ff ff ff       	call   80106488 <uva2ka>
    if(pa0 == 0)
8010652a:	85 c0                	test   %eax,%eax
8010652c:	75 aa                	jne    801064d8 <copyout+0x20>
      return -1;
8010652e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106533:	83 c4 2c             	add    $0x2c,%esp
80106536:	5b                   	pop    %ebx
80106537:	5e                   	pop    %esi
80106538:	5f                   	pop    %edi
80106539:	5d                   	pop    %ebp
8010653a:	c3                   	ret    
8010653b:	90                   	nop
  return 0;
8010653c:	31 c0                	xor    %eax,%eax
}
8010653e:	83 c4 2c             	add    $0x2c,%esp
80106541:	5b                   	pop    %ebx
80106542:	5e                   	pop    %esi
80106543:	5f                   	pop    %edi
80106544:	5d                   	pop    %ebp
80106545:	c3                   	ret    
80106546:	66 90                	xchg   %ax,%ax

80106548 <printk_str>:
#include "types.h"
#include "defs.h"

int
printk_str(char *str){
80106548:	55                   	push   %ebp
80106549:	89 e5                	mov    %esp,%ebp
8010654b:	83 ec 18             	sub    $0x18,%esp
    cprintf("%s\n", str);
8010654e:	8b 45 08             	mov    0x8(%ebp),%eax
80106551:	89 44 24 04          	mov    %eax,0x4(%esp)
80106555:	c7 04 24 00 76 10 80 	movl   $0x80107600,(%esp)
8010655c:	e8 53 a0 ff ff       	call   801005b4 <cprintf>
    return 0xABCDABCD;
}
80106561:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
80106566:	c9                   	leave  
80106567:	c3                   	ret    

80106568 <sys_myfunction>:

//Wrapper for my_syscall
int
sys_myfunction(void){
80106568:	55                   	push   %ebp
80106569:	89 e5                	mov    %esp,%ebp
8010656b:	83 ec 28             	sub    $0x28,%esp
    char *str;
    //Decode argument using argstr
    if(argstr(0, &str) < 0)
8010656e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106571:	89 44 24 04          	mov    %eax,0x4(%esp)
80106575:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010657c:	e8 ff da ff ff       	call   80104080 <argstr>
80106581:	85 c0                	test   %eax,%eax
80106583:	78 1b                	js     801065a0 <sys_myfunction+0x38>
    cprintf("%s\n", str);
80106585:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106588:	89 44 24 04          	mov    %eax,0x4(%esp)
8010658c:	c7 04 24 00 76 10 80 	movl   $0x80107600,(%esp)
80106593:	e8 1c a0 ff ff       	call   801005b4 <cprintf>
        return -1;
    return printk_str(str);
80106598:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
}
8010659d:	c9                   	leave  
8010659e:	c3                   	ret    
8010659f:	90                   	nop
        return -1;
801065a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065a5:	c9                   	leave  
801065a6:	c3                   	ret    
801065a7:	90                   	nop

801065a8 <push_MLFQ>:

// Push process into feedback queue
// It needs queue level to push
int
push_MLFQ(int prior, struct proc* p)
{
801065a8:	55                   	push   %ebp
801065a9:	89 e5                	mov    %esp,%ebp
801065ab:	53                   	push   %ebx
801065ac:	8b 4d 08             	mov    0x8(%ebp),%ecx
801065af:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if(prior < 0 || prior > 2)
801065b2:	83 f9 02             	cmp    $0x2,%ecx
801065b5:	77 59                	ja     80106610 <push_MLFQ+0x68>
push_MLFQ(int prior, struct proc* p)
801065b7:	89 c8                	mov    %ecx,%eax
801065b9:	c1 e0 08             	shl    $0x8,%eax
801065bc:	8d 14 c8             	lea    (%eax,%ecx,8),%edx
801065bf:	31 c0                	xor    %eax,%eax
801065c1:	eb 07                	jmp    801065ca <push_MLFQ+0x22>
801065c3:	90                   	nop
		return -1;
	int i;
	for(i = 0; i < NPROC; i++){
801065c4:	40                   	inc    %eax
801065c5:	83 f8 40             	cmp    $0x40,%eax
801065c8:	74 46                	je     80106610 <push_MLFQ+0x68>
		if(MLFQ_table[prior].wait[i] == 0){
801065ca:	83 bc 82 08 5d 11 80 	cmpl   $0x0,-0x7feea2f8(%edx,%eax,4)
801065d1:	00 
801065d2:	75 f0                	jne    801065c4 <push_MLFQ+0x1c>
			MLFQ_table[prior].wait[i] = p;
801065d4:	89 ca                	mov    %ecx,%edx
801065d6:	c1 e2 06             	shl    $0x6,%edx
801065d9:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
801065dc:	01 d0                	add    %edx,%eax
801065de:	89 1c 85 08 5d 11 80 	mov    %ebx,-0x7feea2f8(,%eax,4)
			p->prior = prior;
801065e5:	89 4b 7c             	mov    %ecx,0x7c(%ebx)
			p->pticks = 0;
801065e8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
801065ef:	00 00 00 
			p->myst = s_cand;
801065f2:	c7 83 84 00 00 00 00 	movl   $0x80115800,0x84(%ebx)
801065f9:	58 11 80 
			MLFQ_table[prior].total++;
801065fc:	89 c8                	mov    %ecx,%eax
801065fe:	c1 e0 08             	shl    $0x8,%eax
80106601:	ff 84 c8 00 5d 11 80 	incl   -0x7feea300(%eax,%ecx,8)
			return 0;
80106608:	31 c0                	xor    %eax,%eax
		}
	}
	return -1;
}
8010660a:	5b                   	pop    %ebx
8010660b:	5d                   	pop    %ebp
8010660c:	c3                   	ret    
8010660d:	8d 76 00             	lea    0x0(%esi),%esi
		return -1;
80106610:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106615:	5b                   	pop    %ebx
80106616:	5d                   	pop    %ebp
80106617:	c3                   	ret    

80106618 <pop_MLFQ>:

// Pop process from feedback queue
int
pop_MLFQ(struct proc* p)
{
80106618:	55                   	push   %ebp
80106619:	89 e5                	mov    %esp,%ebp
8010661b:	53                   	push   %ebx
8010661c:	8b 55 08             	mov    0x8(%ebp),%edx
	int prior = p->prior;
8010661f:	8b 5a 7c             	mov    0x7c(%edx),%ebx
pop_MLFQ(struct proc* p)
80106622:	89 d8                	mov    %ebx,%eax
80106624:	c1 e0 08             	shl    $0x8,%eax
80106627:	8d 0c d8             	lea    (%eax,%ebx,8),%ecx
	int i;
	for(i = 0; i < NPROC; i++){
8010662a:	31 c0                	xor    %eax,%eax
8010662c:	eb 08                	jmp    80106636 <pop_MLFQ+0x1e>
8010662e:	66 90                	xchg   %ax,%ax
80106630:	40                   	inc    %eax
80106631:	83 f8 40             	cmp    $0x40,%eax
80106634:	74 3a                	je     80106670 <pop_MLFQ+0x58>
		if(MLFQ_table[prior].wait[i] == p){
80106636:	39 94 81 08 5d 11 80 	cmp    %edx,-0x7feea2f8(%ecx,%eax,4)
8010663d:	75 f1                	jne    80106630 <pop_MLFQ+0x18>
			MLFQ_table[prior].wait[i] = 0;
8010663f:	89 d9                	mov    %ebx,%ecx
80106641:	c1 e1 06             	shl    $0x6,%ecx
80106644:	8d 0c 59             	lea    (%ecx,%ebx,2),%ecx
80106647:	01 c8                	add    %ecx,%eax
80106649:	c7 04 85 08 5d 11 80 	movl   $0x0,-0x7feea2f8(,%eax,4)
80106650:	00 00 00 00 
			p->pticks = 0;
80106654:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
8010665b:	00 00 00 
			MLFQ_table[prior].total--;
8010665e:	89 d8                	mov    %ebx,%eax
80106660:	c1 e0 08             	shl    $0x8,%eax
80106663:	ff 8c d8 00 5d 11 80 	decl   -0x7feea300(%eax,%ebx,8)
			return 0;
8010666a:	31 c0                	xor    %eax,%eax
		}
	}
	return -1;
}
8010666c:	5b                   	pop    %ebx
8010666d:	5d                   	pop    %ebp
8010666e:	c3                   	ret    
8010666f:	90                   	nop
	return -1;
80106670:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106675:	5b                   	pop    %ebx
80106676:	5d                   	pop    %ebp
80106677:	c3                   	ret    

80106678 <move_MLFQ_prior>:

// Pop process from one feedback queue
// Then push it to new level
int
move_MLFQ_prior(int prior, struct proc* p)
{
80106678:	55                   	push   %ebp
80106679:	89 e5                	mov    %esp,%ebp
8010667b:	56                   	push   %esi
8010667c:	53                   	push   %ebx
8010667d:	8b 5d 08             	mov    0x8(%ebp),%ebx
80106680:	8b 55 0c             	mov    0xc(%ebp),%edx
	int prior = p->prior;
80106683:	8b 72 7c             	mov    0x7c(%edx),%esi
move_MLFQ_prior(int prior, struct proc* p)
80106686:	89 f0                	mov    %esi,%eax
80106688:	c1 e0 08             	shl    $0x8,%eax
8010668b:	8d 0c f0             	lea    (%eax,%esi,8),%ecx
	for(i = 0; i < NPROC; i++){
8010668e:	31 c0                	xor    %eax,%eax
80106690:	eb 0c                	jmp    8010669e <move_MLFQ_prior+0x26>
80106692:	66 90                	xchg   %ax,%ax
80106694:	40                   	inc    %eax
80106695:	83 f8 40             	cmp    $0x40,%eax
80106698:	0f 84 92 00 00 00    	je     80106730 <move_MLFQ_prior+0xb8>
		if(MLFQ_table[prior].wait[i] == p){
8010669e:	3b 94 81 08 5d 11 80 	cmp    -0x7feea2f8(%ecx,%eax,4),%edx
801066a5:	75 ed                	jne    80106694 <move_MLFQ_prior+0x1c>
			MLFQ_table[prior].wait[i] = 0;
801066a7:	89 f1                	mov    %esi,%ecx
801066a9:	c1 e1 06             	shl    $0x6,%ecx
801066ac:	8d 0c 71             	lea    (%ecx,%esi,2),%ecx
801066af:	01 c8                	add    %ecx,%eax
801066b1:	c7 04 85 08 5d 11 80 	movl   $0x0,-0x7feea2f8(,%eax,4)
801066b8:	00 00 00 00 
			p->pticks = 0;
801066bc:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
801066c3:	00 00 00 
			MLFQ_table[prior].total--;
801066c6:	89 f0                	mov    %esi,%eax
801066c8:	c1 e0 08             	shl    $0x8,%eax
801066cb:	ff 8c f0 00 5d 11 80 	decl   -0x7feea300(%eax,%esi,8)
	if(prior < 0 || prior > 2)
801066d2:	83 fb 02             	cmp    $0x2,%ebx
801066d5:	77 59                	ja     80106730 <move_MLFQ_prior+0xb8>
move_MLFQ_prior(int prior, struct proc* p)
801066d7:	89 d8                	mov    %ebx,%eax
801066d9:	c1 e0 08             	shl    $0x8,%eax
801066dc:	8d 0c d8             	lea    (%eax,%ebx,8),%ecx
801066df:	31 c0                	xor    %eax,%eax
801066e1:	eb 07                	jmp    801066ea <move_MLFQ_prior+0x72>
801066e3:	90                   	nop
	for(i = 0; i < NPROC; i++){
801066e4:	40                   	inc    %eax
801066e5:	83 f8 40             	cmp    $0x40,%eax
801066e8:	74 46                	je     80106730 <move_MLFQ_prior+0xb8>
		if(MLFQ_table[prior].wait[i] == 0){
801066ea:	8b b4 81 08 5d 11 80 	mov    -0x7feea2f8(%ecx,%eax,4),%esi
801066f1:	85 f6                	test   %esi,%esi
801066f3:	75 ef                	jne    801066e4 <move_MLFQ_prior+0x6c>
			MLFQ_table[prior].wait[i] = p;
801066f5:	89 d9                	mov    %ebx,%ecx
801066f7:	c1 e1 06             	shl    $0x6,%ecx
801066fa:	8d 0c 59             	lea    (%ecx,%ebx,2),%ecx
801066fd:	01 c8                	add    %ecx,%eax
801066ff:	89 14 85 08 5d 11 80 	mov    %edx,-0x7feea2f8(,%eax,4)
			p->prior = prior;
80106706:	89 5a 7c             	mov    %ebx,0x7c(%edx)
			p->pticks = 0;
80106709:	c7 82 80 00 00 00 00 	movl   $0x0,0x80(%edx)
80106710:	00 00 00 
			p->myst = s_cand;
80106713:	c7 82 84 00 00 00 00 	movl   $0x80115800,0x84(%edx)
8010671a:	58 11 80 
			MLFQ_table[prior].total++;
8010671d:	89 d8                	mov    %ebx,%eax
8010671f:	c1 e0 08             	shl    $0x8,%eax
80106722:	ff 84 d8 00 5d 11 80 	incl   -0x7feea300(%eax,%ebx,8)
			return 0;
80106729:	31 c0                	xor    %eax,%eax
	int ret = pop_MLFQ(p);
	if(ret == -1)
		return ret;
	return push_MLFQ(prior, p);
}
8010672b:	5b                   	pop    %ebx
8010672c:	5e                   	pop    %esi
8010672d:	5d                   	pop    %ebp
8010672e:	c3                   	ret    
8010672f:	90                   	nop
		return -1;
80106730:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106735:	5b                   	pop    %ebx
80106736:	5e                   	pop    %esi
80106737:	5d                   	pop    %ebp
80106738:	c3                   	ret    
80106739:	8d 76 00             	lea    0x0(%esi),%esi

8010673c <pick_MLFQ>:

// It picks process from MLFQ
struct proc*
pick_MLFQ(void)
{
8010673c:	55                   	push   %ebp
8010673d:	89 e5                	mov    %esp,%ebp
8010673f:	57                   	push   %edi
80106740:	56                   	push   %esi
80106741:	53                   	push   %ebx
80106742:	83 ec 08             	sub    $0x8,%esp
80106745:	c7 45 ec 00 5d 11 80 	movl   $0x80115d00,-0x14(%ebp)

	int i, j;

	for(i = 0; i < 3; i++){
8010674c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		if(MLFQ_table[i].total == 0){
80106753:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106756:	8b 38                	mov    (%eax),%edi
80106758:	85 ff                	test   %edi,%edi
8010675a:	74 40                	je     8010679c <pick_MLFQ+0x60>
			continue; // no process in feedback queue
		}
		j = MLFQ_table[i].recent; // like rear in queue structure
8010675c:	8b 70 04             	mov    0x4(%eax),%esi
8010675f:	89 f1                	mov    %esi,%ecx
		do{
			j = (j + 1) % NPROC; // pick next to recently picked proc
			if(MLFQ_table[i].wait[j] != 0 && 
80106761:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106764:	c1 e0 06             	shl    $0x6,%eax
80106767:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010676a:	8d 3c 50             	lea    (%eax,%edx,2),%edi
8010676d:	eb 1b                	jmp    8010678a <pick_MLFQ+0x4e>
8010676f:	90                   	nop
			j = (j + 1) % NPROC; // pick next to recently picked proc
80106770:	89 c1                	mov    %eax,%ecx
			if(MLFQ_table[i].wait[j] != 0 && 
80106772:	8d 1c 07             	lea    (%edi,%eax,1),%ebx
80106775:	8b 14 9d 08 5d 11 80 	mov    -0x7feea2f8(,%ebx,4),%edx
8010677c:	85 d2                	test   %edx,%edx
8010677e:	74 06                	je     80106786 <pick_MLFQ+0x4a>
80106780:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
80106784:	74 32                	je     801067b8 <pick_MLFQ+0x7c>
				MLFQ_table[i].wait[j]->state == RUNNABLE){
				MLFQ_table[i].recent = j;
				return MLFQ_table[i].wait[j];
			}
		}while(j != MLFQ_table[i].recent);
80106786:	39 c6                	cmp    %eax,%esi
80106788:	74 12                	je     8010679c <pick_MLFQ+0x60>
			j = (j + 1) % NPROC; // pick next to recently picked proc
8010678a:	8d 41 01             	lea    0x1(%ecx),%eax
8010678d:	25 3f 00 00 80       	and    $0x8000003f,%eax
80106792:	79 dc                	jns    80106770 <pick_MLFQ+0x34>
80106794:	48                   	dec    %eax
80106795:	83 c8 c0             	or     $0xffffffc0,%eax
80106798:	40                   	inc    %eax
80106799:	eb d5                	jmp    80106770 <pick_MLFQ+0x34>
8010679b:	90                   	nop
	for(i = 0; i < 3; i++){
8010679c:	ff 45 f0             	incl   -0x10(%ebp)
8010679f:	81 45 ec 08 01 00 00 	addl   $0x108,-0x14(%ebp)
801067a6:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
801067aa:	75 a7                	jne    80106753 <pick_MLFQ+0x17>
	}
	
	return 0; // There are no process in MLFQ
801067ac:	31 c0                	xor    %eax,%eax
}
801067ae:	83 c4 08             	add    $0x8,%esp
801067b1:	5b                   	pop    %ebx
801067b2:	5e                   	pop    %esi
801067b3:	5f                   	pop    %edi
801067b4:	5d                   	pop    %ebp
801067b5:	c3                   	ret    
801067b6:	66 90                	xchg   %ax,%ax
				MLFQ_table[i].recent = j;
801067b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801067bb:	c1 e2 08             	shl    $0x8,%edx
801067be:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801067c1:	89 84 ca 04 5d 11 80 	mov    %eax,-0x7feea2fc(%edx,%ecx,8)
				return MLFQ_table[i].wait[j];
801067c8:	8b 04 9d 08 5d 11 80 	mov    -0x7feea2f8(,%ebx,4),%eax
}
801067cf:	83 c4 08             	add    $0x8,%esp
801067d2:	5b                   	pop    %ebx
801067d3:	5e                   	pop    %esi
801067d4:	5f                   	pop    %edi
801067d5:	5d                   	pop    %ebp
801067d6:	c3                   	ret    
801067d7:	90                   	nop

801067d8 <prior_boost>:

// MLFQ scheduler boost priority of all
// process in MLFQ for process executed periodically
void 
prior_boost(void)
{
801067d8:	55                   	push   %ebp
801067d9:	89 e5                	mov    %esp,%ebp
801067db:	53                   	push   %ebx
801067dc:	83 ec 14             	sub    $0x14,%esp
  	struct proc* p;
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
801067df:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801067e4:	eb 10                	jmp    801067f6 <prior_boost+0x1e>
801067e6:	66 90                	xchg   %ax,%ax
801067e8:	81 c3 88 00 00 00    	add    $0x88,%ebx
801067ee:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
801067f4:	74 24                	je     8010681a <prior_boost+0x42>
		if(p->prior == 0 || p->prior == 1|| p->prior == 2) { 
801067f6:	83 7b 7c 02          	cmpl   $0x2,0x7c(%ebx)
801067fa:	77 ec                	ja     801067e8 <prior_boost+0x10>
			move_MLFQ_prior(0, p);
801067fc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106800:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106807:	e8 6c fe ff ff       	call   80106678 <move_MLFQ_prior>
	for(p = ptable.proc; p < &ptable.proc[NPROC]; p++) {
8010680c:	81 c3 88 00 00 00    	add    $0x88,%ebx
80106812:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80106818:	75 dc                	jne    801067f6 <prior_boost+0x1e>
		}
	}
	acquire(&gticklock);
8010681a:	c7 04 24 c0 57 11 80 	movl   $0x801157c0,(%esp)
80106821:	e8 6a d4 ff ff       	call   80103c90 <acquire>
    MLFQ_ticks = 0;
80106826:	c7 05 18 60 11 80 00 	movl   $0x0,0x80116018
8010682d:	00 00 00 
    release(&gticklock);
80106830:	c7 04 24 c0 57 11 80 	movl   $0x801157c0,(%esp)
80106837:	e8 10 d5 ff ff       	call   80103d4c <release>
	
	
}
8010683c:	83 c4 14             	add    $0x14,%esp
8010683f:	5b                   	pop    %ebx
80106840:	5d                   	pop    %ebp
80106841:	c3                   	ret    
80106842:	66 90                	xchg   %ax,%ax

80106844 <pick_pass>:

// Stride schduler
// pick min_pass stride structure
struct proc*
pick_pass(void)
{
80106844:	55                   	push   %ebp
80106845:	89 e5                	mov    %esp,%ebp
80106847:	53                   	push   %ebx
	struct stride* pick = s_cand;
	struct stride* s;
	// round stride structure for finding min_pass
	for(s = s_cand; s < &s_cand[NPROC]; s++){
80106848:	b8 00 58 11 80       	mov    $0x80115800,%eax
	struct stride* pick = s_cand;
8010684d:	89 c3                	mov    %eax,%ebx
8010684f:	eb 0d                	jmp    8010685e <pick_pass+0x1a>
80106851:	8d 76 00             	lea    0x0(%esi),%esi
	for(s = s_cand; s < &s_cand[NPROC]; s++){
80106854:	83 c0 14             	add    $0x14,%eax
80106857:	3d 00 5d 11 80       	cmp    $0x80115d00,%eax
8010685c:	73 26                	jae    80106884 <pick_pass+0x40>
		// if stride structure not yet used
		if(s->valid == 0){
8010685e:	8b 48 0c             	mov    0xc(%eax),%ecx
80106861:	85 c9                	test   %ecx,%ecx
80106863:	74 ef                	je     80106854 <pick_pass+0x10>
			continue;
		}
		if(s->proc->state != RUNNABLE){
80106865:	8b 50 10             	mov    0x10(%eax),%edx
80106868:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
8010686c:	75 e6                	jne    80106854 <pick_pass+0x10>
			// in case not runnable
			continue;
		}
		if(s->pass < pick->pass)
8010686e:	8b 53 04             	mov    0x4(%ebx),%edx
80106871:	39 50 04             	cmp    %edx,0x4(%eax)
80106874:	7d de                	jge    80106854 <pick_pass+0x10>
80106876:	89 c3                	mov    %eax,%ebx
	for(s = s_cand; s < &s_cand[NPROC]; s++){
80106878:	83 c0 14             	add    $0x14,%eax
8010687b:	3d 00 5d 11 80       	cmp    $0x80115d00,%eax
80106880:	72 dc                	jb     8010685e <pick_pass+0x1a>
80106882:	66 90                	xchg   %ax,%ax
			pick = s;
	}
	// case 1 : min_pass structure is MLFQ
	// so, MLFQ runs under Stride scheduler
	if(pick == s_cand){
80106884:	81 fb 00 58 11 80    	cmp    $0x80115800,%ebx
8010688a:	74 06                	je     80106892 <pick_pass+0x4e>
			// return secondly min pass process
			return pick->proc;
		}
		return mlfq_proc;
	}
	return pick->proc;
8010688c:	8b 43 10             	mov    0x10(%ebx),%eax
}
8010688f:	5b                   	pop    %ebx
80106890:	5d                   	pop    %ebp
80106891:	c3                   	ret    
		struct proc* mlfq_proc = pick_MLFQ();
80106892:	e8 a5 fe ff ff       	call   8010673c <pick_MLFQ>
		if(mlfq_proc == 0){
80106897:	85 c0                	test   %eax,%eax
80106899:	75 f4                	jne    8010688f <pick_pass+0x4b>
8010689b:	b9 00 84 d7 17       	mov    $0x17d78400,%ecx
801068a0:	b8 14 58 11 80       	mov    $0x80115814,%eax
801068a5:	eb 0b                	jmp    801068b2 <pick_pass+0x6e>
801068a7:	90                   	nop
			for(s = &s_cand[1]; s < &s_cand[NPROC]; s++){
801068a8:	83 c0 14             	add    $0x14,%eax
801068ab:	3d 00 5d 11 80       	cmp    $0x80115d00,%eax
801068b0:	74 da                	je     8010688c <pick_pass+0x48>
				if(s->valid == 0)
801068b2:	8b 50 0c             	mov    0xc(%eax),%edx
801068b5:	85 d2                	test   %edx,%edx
801068b7:	74 ef                	je     801068a8 <pick_pass+0x64>
				if(s->proc->state != RUNNABLE)
801068b9:	8b 50 10             	mov    0x10(%eax),%edx
801068bc:	83 7a 0c 03          	cmpl   $0x3,0xc(%edx)
801068c0:	75 e6                	jne    801068a8 <pick_pass+0x64>
				if(s->pass < min){
801068c2:	8b 50 04             	mov    0x4(%eax),%edx
801068c5:	39 ca                	cmp    %ecx,%edx
801068c7:	73 df                	jae    801068a8 <pick_pass+0x64>
801068c9:	89 d1                	mov    %edx,%ecx
801068cb:	89 c3                	mov    %eax,%ebx
801068cd:	eb d9                	jmp    801068a8 <pick_pass+0x64>
801068cf:	90                   	nop

801068d0 <scheduler>:
//      via swtch back to the scheduler.


void
scheduler(void)
{
801068d0:	55                   	push   %ebp
801068d1:	89 e5                	mov    %esp,%ebp
801068d3:	57                   	push   %edi
801068d4:	56                   	push   %esi
801068d5:	53                   	push   %ebx
801068d6:	83 ec 2c             	sub    $0x2c,%esp
  struct proc *p;
  struct proc *win;
  struct cpu *c = mycpu();
801068d9:	e8 92 c9 ff ff       	call   80103270 <mycpu>
801068de:	89 c6                	mov    %eax,%esi
  c->proc = 0;
801068e0:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801068e7:	00 00 00 
801068ea:	8d 78 04             	lea    0x4(%eax),%edi
801068ed:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801068f0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801068f1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801068f8:	e8 93 d3 ff ff       	call   80103c90 <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801068fd:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80106902:	eb 0e                	jmp    80106912 <scheduler+0x42>
80106904:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010690a:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80106910:	74 56                	je     80106968 <scheduler+0x98>
      if(p->state != RUNNABLE)
80106912:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80106916:	75 ec                	jne    80106904 <scheduler+0x34>
        continue;
    	// find process by Stride scheduler
      win = pick_pass();
80106918:	e8 27 ff ff ff       	call   80106844 <pick_pass>
      if(win == 0){
8010691d:	85 c0                	test   %eax,%eax
8010691f:	74 58                	je     80106979 <scheduler+0xa9>
      	win = p;
      }
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = win;
80106921:	89 86 ac 00 00 00    	mov    %eax,0xac(%esi)
      switchuvm(win);
80106927:	89 04 24             	mov    %eax,(%esp)
8010692a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010692d:	e8 3a f5 ff ff       	call   80105e6c <switchuvm>
      win->state = RUNNING;
80106932:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106935:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)

      swtch(&(c->scheduler), win->context);
8010693c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010693f:	89 44 24 04          	mov    %eax,0x4(%esp)
80106943:	89 3c 24             	mov    %edi,(%esp)
80106946:	e8 2a d6 ff ff       	call   80103f75 <swtch>
      //myproc()->pticks++;
      switchkvm();
8010694b:	e8 08 f5 ff ff       	call   80105e58 <switchkvm>
      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80106950:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80106957:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010695a:	81 c3 88 00 00 00    	add    $0x88,%ebx
80106960:	81 fb 54 4f 11 80    	cmp    $0x80114f54,%ebx
80106966:	75 aa                	jne    80106912 <scheduler+0x42>
    }
    release(&ptable.lock);
80106968:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010696f:	e8 d8 d3 ff ff       	call   80103d4c <release>

  }
80106974:	e9 77 ff ff ff       	jmp    801068f0 <scheduler+0x20>
      	cprintf("fatal pick\n");
80106979:	c7 04 24 04 76 10 80 	movl   $0x80107604,(%esp)
80106980:	e8 2f 9c ff ff       	call   801005b4 <cprintf>
80106985:	89 d8                	mov    %ebx,%eax
80106987:	eb 98                	jmp    80106921 <scheduler+0x51>
80106989:	8d 76 00             	lea    0x0(%esi),%esi

8010698c <set_cpu_share>:
}

// Call OS for share CPU share
int
set_cpu_share(int inquire)
{	
8010698c:	55                   	push   %ebp
8010698d:	89 e5                	mov    %esp,%ebp
8010698f:	57                   	push   %edi
80106990:	56                   	push   %esi
80106991:	53                   	push   %ebx
80106992:	83 ec 0c             	sub    $0xc,%esp
80106995:	8b 75 08             	mov    0x8(%ebp),%esi
	// share should be over 0
	if(inquire <= 0)
80106998:	85 f6                	test   %esi,%esi
8010699a:	0f 8e 0e 01 00 00    	jle    80106aae <set_cpu_share+0x122>
		return -1;
	// already call this function
	if(myproc()->myst != s_cand){
801069a0:	e8 73 c9 ff ff       	call   80103318 <myproc>
801069a5:	81 b8 84 00 00 00 00 	cmpl   $0x80115800,0x84(%eax)
801069ac:	58 11 80 
801069af:	0f 85 f9 00 00 00    	jne    80106aae <set_cpu_share+0x122>
801069b5:	89 f3                	mov    %esi,%ebx
801069b7:	b9 00 84 d7 17       	mov    $0x17d78400,%ecx
801069bc:	b8 00 58 11 80       	mov    $0x80115800,%eax
801069c1:	eb 0b                	jmp    801069ce <set_cpu_share+0x42>
801069c3:	90                   	nop
	}
	struct stride* s;
	uint min_pass = 400000000;
	// count all share
	int sum = inquire;
	for(s = s_cand; s < &s_cand[NPROC]; s++){
801069c4:	83 c0 14             	add    $0x14,%eax
801069c7:	3d 00 5d 11 80       	cmp    $0x80115d00,%eax
801069cc:	73 1e                	jae    801069ec <set_cpu_share+0x60>
		if(s->valid == 1){
801069ce:	83 78 0c 01          	cmpl   $0x1,0xc(%eax)
801069d2:	75 f0                	jne    801069c4 <set_cpu_share+0x38>
			sum += s->share;
801069d4:	03 58 08             	add    0x8(%eax),%ebx
			if(min_pass > s->pass)
801069d7:	8b 50 04             	mov    0x4(%eax),%edx
801069da:	39 ca                	cmp    %ecx,%edx
801069dc:	73 e6                	jae    801069c4 <set_cpu_share+0x38>
801069de:	89 d1                	mov    %edx,%ecx
	for(s = s_cand; s < &s_cand[NPROC]; s++){
801069e0:	83 c0 14             	add    $0x14,%eax
801069e3:	3d 00 5d 11 80       	cmp    $0x80115d00,%eax
801069e8:	72 e4                	jb     801069ce <set_cpu_share+0x42>
801069ea:	66 90                	xchg   %ax,%ax
				min_pass = s->pass;
		}
	}
	sum -= s_cand[0].share;
801069ec:	2b 1d 08 58 11 80    	sub    0x80115808,%ebx
	// already over max share
	if(sum > 80)
801069f2:	83 fb 50             	cmp    $0x50,%ebx
801069f5:	0f 8f b3 00 00 00    	jg     80106aae <set_cpu_share+0x122>
		return -1;
	// set share for MLFQ(min 20)
	s_cand[0].share = (100 - sum);
801069fb:	bf 64 00 00 00       	mov    $0x64,%edi
80106a00:	29 df                	sub    %ebx,%edi
80106a02:	89 3d 08 58 11 80    	mov    %edi,0x80115808
	s_cand[0].stride = 10000000 / s_cand[0].share;
80106a08:	b8 80 96 98 00       	mov    $0x989680,%eax
80106a0d:	99                   	cltd   
80106a0e:	f7 ff                	idiv   %edi
80106a10:	a3 00 58 11 80       	mov    %eax,0x80115800
	
	// find stride structure
	for(s = s_cand; s < &s_cand[NPROC]; s++){
80106a15:	bb 00 58 11 80       	mov    $0x80115800,%ebx
80106a1a:	eb 0b                	jmp    80106a27 <set_cpu_share+0x9b>
80106a1c:	83 c3 14             	add    $0x14,%ebx
80106a1f:	81 fb 00 5d 11 80    	cmp    $0x80115d00,%ebx
80106a25:	73 07                	jae    80106a2e <set_cpu_share+0xa2>
		if(s->valid == 0)
80106a27:	8b 7b 0c             	mov    0xc(%ebx),%edi
80106a2a:	85 ff                	test   %edi,%edi
80106a2c:	75 ee                	jne    80106a1c <set_cpu_share+0x90>
			break;
	}
	s->share = inquire;
80106a2e:	89 73 08             	mov    %esi,0x8(%ebx)
	s->stride = 10000000 / inquire;
80106a31:	b8 80 96 98 00       	mov    $0x989680,%eax
80106a36:	99                   	cltd   
80106a37:	f7 fe                	idiv   %esi
80106a39:	89 03                	mov    %eax,(%ebx)
	s->pass = min_pass;
80106a3b:	89 4b 04             	mov    %ecx,0x4(%ebx)
	struct proc* p = myproc();
80106a3e:	e8 d5 c8 ff ff       	call   80103318 <myproc>
	// stride structure and process structure
	// points each other
	s->proc = p;
80106a43:	89 43 10             	mov    %eax,0x10(%ebx)
	p->myst = s;
80106a46:	89 98 84 00 00 00    	mov    %ebx,0x84(%eax)
	int prior = p->prior;
80106a4c:	8b 70 7c             	mov    0x7c(%eax),%esi
set_cpu_share(int inquire)
80106a4f:	89 f2                	mov    %esi,%edx
80106a51:	c1 e2 08             	shl    $0x8,%edx
80106a54:	8d 0c f2             	lea    (%edx,%esi,8),%ecx
	for(i = 0; i < NPROC; i++){
80106a57:	31 d2                	xor    %edx,%edx
80106a59:	eb 07                	jmp    80106a62 <set_cpu_share+0xd6>
80106a5b:	90                   	nop
80106a5c:	42                   	inc    %edx
80106a5d:	83 fa 40             	cmp    $0x40,%edx
80106a60:	74 34                	je     80106a96 <set_cpu_share+0x10a>
		if(MLFQ_table[prior].wait[i] == p){
80106a62:	3b 84 91 08 5d 11 80 	cmp    -0x7feea2f8(%ecx,%edx,4),%eax
80106a69:	75 f1                	jne    80106a5c <set_cpu_share+0xd0>
			MLFQ_table[prior].wait[i] = 0;
80106a6b:	89 f1                	mov    %esi,%ecx
80106a6d:	c1 e1 06             	shl    $0x6,%ecx
80106a70:	8d 0c 71             	lea    (%ecx,%esi,2),%ecx
80106a73:	01 ca                	add    %ecx,%edx
80106a75:	c7 04 95 08 5d 11 80 	movl   $0x0,-0x7feea2f8(,%edx,4)
80106a7c:	00 00 00 00 
			p->pticks = 0;
80106a80:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80106a87:	00 00 00 
			MLFQ_table[prior].total--;
80106a8a:	89 f2                	mov    %esi,%edx
80106a8c:	c1 e2 08             	shl    $0x8,%edx
80106a8f:	ff 8c f2 00 5d 11 80 	decl   -0x7feea300(%edx,%esi,8)
	// it runs on stride scheduler
	pop_MLFQ(p);
	p->prior = 3;
80106a96:	c7 40 7c 03 00 00 00 	movl   $0x3,0x7c(%eax)
	s->valid = 1;
80106a9d:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
	return 0;
80106aa4:	31 c0                	xor    %eax,%eax
}
80106aa6:	83 c4 0c             	add    $0xc,%esp
80106aa9:	5b                   	pop    %ebx
80106aaa:	5e                   	pop    %esi
80106aab:	5f                   	pop    %edi
80106aac:	5d                   	pop    %ebp
80106aad:	c3                   	ret    
		return -1;
80106aae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106ab3:	83 c4 0c             	add    $0xc,%esp
80106ab6:	5b                   	pop    %ebx
80106ab7:	5e                   	pop    %esi
80106ab8:	5f                   	pop    %edi
80106ab9:	5d                   	pop    %ebp
80106aba:	c3                   	ret    
80106abb:	90                   	nop

80106abc <stride_adder>:

// add stride to pass
void
stride_adder(int step)
{
80106abc:	55                   	push   %ebp
80106abd:	89 e5                	mov    %esp,%ebp
80106abf:	56                   	push   %esi
80106ac0:	53                   	push   %ebx
80106ac1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	struct stride* s = myproc()->myst;
80106ac4:	e8 4f c8 ff ff       	call   80103318 <myproc>
80106ac9:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
	int i;
	for(i = 0; i < step; i++){
80106acf:	85 db                	test   %ebx,%ebx
80106ad1:	7e 36                	jle    80106b09 <stride_adder+0x4d>
80106ad3:	8b 08                	mov    (%eax),%ecx
stride_adder(int step)
80106ad5:	8b 70 04             	mov    0x4(%eax),%esi
80106ad8:	01 ce                	add    %ecx,%esi
80106ada:	8d 53 ff             	lea    -0x1(%ebx),%edx
80106add:	0f af d1             	imul   %ecx,%edx
80106ae0:	01 f2                	add    %esi,%edx
80106ae2:	89 50 04             	mov    %edx,0x4(%eax)
		s->pass += s->stride;
	}
	// for prevent overflow
	if(s->pass > 300000000){
80106ae5:	81 fa 00 a3 e1 11    	cmp    $0x11e1a300,%edx
80106aeb:	7e 18                	jle    80106b05 <stride_adder+0x49>
80106aed:	b8 00 58 11 80       	mov    $0x80115800,%eax
80106af2:	66 90                	xchg   %ax,%ax
		for(s = s_cand; s < &s_cand[NPROC]; s++){
			s->pass = 0;
80106af4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
		for(s = s_cand; s < &s_cand[NPROC]; s++){
80106afb:	83 c0 14             	add    $0x14,%eax
80106afe:	3d 00 5d 11 80       	cmp    $0x80115d00,%eax
80106b03:	72 ef                	jb     80106af4 <stride_adder+0x38>
		}
	}
}
80106b05:	5b                   	pop    %ebx
80106b06:	5e                   	pop    %esi
80106b07:	5d                   	pop    %ebp
80106b08:	c3                   	ret    
80106b09:	8b 50 04             	mov    0x4(%eax),%edx
80106b0c:	eb d7                	jmp    80106ae5 <stride_adder+0x29>
80106b0e:	66 90                	xchg   %ax,%ax

80106b10 <MLFQ_tick_adder>:
// and sys_yield()
// return value determine process yield or not
// for guarantee time quantum
int
MLFQ_tick_adder(void)
{
80106b10:	55                   	push   %ebp
80106b11:	89 e5                	mov    %esp,%ebp
80106b13:	56                   	push   %esi
80106b14:	53                   	push   %ebx
80106b15:	83 ec 10             	sub    $0x10,%esp
	acquire(&ptable.lock);
80106b18:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80106b1f:	e8 6c d1 ff ff       	call   80103c90 <acquire>
	// check stride per ticks
	stride_adder(1);
80106b24:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106b2b:	e8 8c ff ff ff       	call   80106abc <stride_adder>
	struct proc* p = myproc();
80106b30:	e8 e3 c7 ff ff       	call   80103318 <myproc>
80106b35:	89 c3                	mov    %eax,%ebx
	// case 1 : run on stride scheduler process
	if(p->prior ==3){
80106b37:	83 78 7c 03          	cmpl   $0x3,0x7c(%eax)
80106b3b:	74 79                	je     80106bb6 <MLFQ_tick_adder+0xa6>
		release(&ptable.lock);
		return 1;
	}
	// case 2 : run on MLFQ scheduler process
	acquire(&gticklock);
80106b3d:	c7 04 24 c0 57 11 80 	movl   $0x801157c0,(%esp)
80106b44:	e8 47 d1 ff ff       	call   80103c90 <acquire>
  MLFQ_ticks++;
80106b49:	ff 05 18 60 11 80    	incl   0x80116018
  release(&gticklock);
80106b4f:	c7 04 24 c0 57 11 80 	movl   $0x801157c0,(%esp)
80106b56:	e8 f1 d1 ff ff       	call   80103d4c <release>
	
        int quantum = ++p->pticks;
80106b5b:	8b b3 80 00 00 00    	mov    0x80(%ebx),%esi
80106b61:	46                   	inc    %esi
80106b62:	89 b3 80 00 00 00    	mov    %esi,0x80(%ebx)
	// when time quantum all consumed
	// then return value is 1
	// which mean prior boost and yield
	// could evoke
	switch(p->prior){
80106b68:	8b 43 7c             	mov    0x7c(%ebx),%eax
80106b6b:	83 f8 01             	cmp    $0x1,%eax
80106b6e:	74 60                	je     80106bd0 <MLFQ_tick_adder+0xc0>
80106b70:	72 1e                	jb     80106b90 <MLFQ_tick_adder+0x80>
80106b72:	83 f8 02             	cmp    $0x2,%eax
80106b75:	74 75                	je     80106bec <MLFQ_tick_adder+0xdc>
				release(&ptable.lock);
				return 0;
			}
			break;
		default:
			release(&ptable.lock);
80106b77:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80106b7e:	e8 c9 d1 ff ff       	call   80103d4c <release>
			return -1;
80106b83:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}	
}
80106b88:	83 c4 10             	add    $0x10,%esp
80106b8b:	5b                   	pop    %ebx
80106b8c:	5e                   	pop    %esi
80106b8d:	5d                   	pop    %ebp
80106b8e:	c3                   	ret    
80106b8f:	90                   	nop
			if(quantum >= 5){
80106b90:	83 fe 04             	cmp    $0x4,%esi
80106b93:	7e 13                	jle    80106ba8 <MLFQ_tick_adder+0x98>
				move_MLFQ_prior(1, p);
80106b95:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106b99:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106ba0:	e8 d3 fa ff ff       	call   80106678 <move_MLFQ_prior>
80106ba5:	8d 76 00             	lea    0x0(%esi),%esi
			if(MLFQ_ticks > 100){	
80106ba8:	83 3d 18 60 11 80 64 	cmpl   $0x64,0x80116018
80106baf:	7e 05                	jle    80106bb6 <MLFQ_tick_adder+0xa6>
				prior_boost();
80106bb1:	e8 22 fc ff ff       	call   801067d8 <prior_boost>
		release(&ptable.lock);
80106bb6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80106bbd:	e8 8a d1 ff ff       	call   80103d4c <release>
		return 1;
80106bc2:	b8 01 00 00 00       	mov    $0x1,%eax
}
80106bc7:	83 c4 10             	add    $0x10,%esp
80106bca:	5b                   	pop    %ebx
80106bcb:	5e                   	pop    %esi
80106bcc:	5d                   	pop    %ebp
80106bcd:	c3                   	ret    
80106bce:	66 90                	xchg   %ax,%ax
			if(quantum >= 10){
80106bd0:	83 fe 09             	cmp    $0x9,%esi
80106bd3:	7f 1f                	jg     80106bf4 <MLFQ_tick_adder+0xe4>
			if((quantum % 2) == 0){
80106bd5:	83 e6 01             	and    $0x1,%esi
80106bd8:	74 ce                	je     80106ba8 <MLFQ_tick_adder+0x98>
				release(&ptable.lock);
80106bda:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80106be1:	e8 66 d1 ff ff       	call   80103d4c <release>
				return 0;
80106be6:	31 c0                	xor    %eax,%eax
80106be8:	eb dd                	jmp    80106bc7 <MLFQ_tick_adder+0xb7>
80106bea:	66 90                	xchg   %ax,%ax
			if((quantum % 4) == 0){
80106bec:	83 e6 03             	and    $0x3,%esi
80106bef:	74 b7                	je     80106ba8 <MLFQ_tick_adder+0x98>
80106bf1:	eb e7                	jmp    80106bda <MLFQ_tick_adder+0xca>
80106bf3:	90                   	nop
				move_MLFQ_prior(2, p);
80106bf4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80106bf8:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106bff:	e8 74 fa ff ff       	call   80106678 <move_MLFQ_prior>
80106c04:	eb cf                	jmp    80106bd5 <MLFQ_tick_adder+0xc5>
